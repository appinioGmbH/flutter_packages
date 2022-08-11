package com.appinio.disable_screenshot;

import android.content.Context;
import android.database.ContentObserver;
import android.database.Cursor;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
import android.view.Display;
import android.view.WindowManager;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;


public class ScreenShotListenManager {
    private static final String TAG = "ScreenShotListenManager";

    private static final String[] MEDIA_PROJECTIONS = {
            MediaStore.Images.ImageColumns.DATA,
            MediaStore.Images.ImageColumns.DATE_TAKEN,
    };
    private static final String[] MEDIA_PROJECTIONS_API_16 = {
            MediaStore.Images.ImageColumns.DATA,
            MediaStore.Images.ImageColumns.DATE_TAKEN,
            MediaStore.Images.ImageColumns.WIDTH,
            MediaStore.Images.ImageColumns.HEIGHT,
    };

    private static final String[] KEYWORDS = {
            "screenshot", "screen_shot", "screen-shot", "screen shot",
            "screencapture", "screen_capture", "screen-capture", "screen capture",
            "screencap", "screen_cap", "screen-cap", "screen cap"
    };

    private static Point sScreenRealSize;

    private final static List<String> sHasCallbackPaths = new ArrayList<String>();

    private Context mContext;

    private OnScreenShotListener mListener;

    private long mStartListenTime;

    private MediaContentObserver mInternalObserver;

    private MediaContentObserver mExternalObserver;

    private final Handler mUiHandler = new Handler(Looper.getMainLooper());

    private ScreenShotListenManager(Context context) {
        if (context == null) {
            throw new IllegalArgumentException("The context must not be null.");
        }
        mContext = context;

        if (sScreenRealSize == null) {
            sScreenRealSize = getRealScreenSize();
            if (sScreenRealSize != null) {
                Log.d(TAG, "Screen Real Size: " + sScreenRealSize.x + " * " + sScreenRealSize.y);
            } else {
                Log.w(TAG, "Get screen real size failed.");
            }
        }
    }

    public static ScreenShotListenManager newInstance(Context context) {
        assertInMainThread();
        return new ScreenShotListenManager(context);
    }

    public void startListen() {
        assertInMainThread();

        mStartListenTime = System.currentTimeMillis();

        mInternalObserver = new MediaContentObserver(MediaStore.Images.Media.INTERNAL_CONTENT_URI, mUiHandler);
        mExternalObserver = new MediaContentObserver(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, mUiHandler);


        mContext.getContentResolver().registerContentObserver(
                MediaStore.Images.Media.INTERNAL_CONTENT_URI,
                false,
                mInternalObserver
        );
        mContext.getContentResolver().registerContentObserver(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                false,
                mExternalObserver
        );
    }

    public void stopListen() {
        assertInMainThread();

        if (mInternalObserver != null) {
            try {
                mContext.getContentResolver().unregisterContentObserver(mInternalObserver);
            } catch (Exception e) {
                e.printStackTrace();
            }
            mInternalObserver = null;
        }
        if (mExternalObserver != null) {
            try {
                mContext.getContentResolver().unregisterContentObserver(mExternalObserver);
            } catch (Exception e) {
                e.printStackTrace();
            }
            mExternalObserver = null;
        }

        mStartListenTime = 0;
        mListener = null;
    }

    private void handleMediaContentChange(Uri contentUri) {
        Cursor cursor = null;
        try {
            cursor = mContext.getContentResolver().query(
                    contentUri,
                    Build.VERSION.SDK_INT < 16 ? MEDIA_PROJECTIONS : MEDIA_PROJECTIONS_API_16,
                    null,
                    null,
                    MediaStore.Images.ImageColumns.DATE_ADDED + " desc limit 1"
            );

            if (cursor == null) {
                Log.e(TAG, "Deviant logic.");
                return;
            }
            if (!cursor.moveToFirst()) {
                Log.d(TAG, "Cursor no data.");
                return;
            }

            int dataIndex = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);
            int dateTakenIndex = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATE_TAKEN);
            int widthIndex = -1;
            int heightIndex = -1;
            if (Build.VERSION.SDK_INT >= 16) {
                widthIndex = cursor.getColumnIndex(MediaStore.Images.ImageColumns.WIDTH);
                heightIndex = cursor.getColumnIndex(MediaStore.Images.ImageColumns.HEIGHT);
            }

            String data = cursor.getString(dataIndex);
            long dateTaken = cursor.getLong(dateTakenIndex);
            int width = 0;
            int height = 0;
            if (widthIndex >= 0 && heightIndex >= 0) {
                width = cursor.getInt(widthIndex);
                height = cursor.getInt(heightIndex);
            } else {
                Point size = getImageSize(data);
                width = size.x;
                height = size.y;
            }

            handleMediaRowData(data, dateTaken, width, height);

        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            if (cursor != null && !cursor.isClosed()) {
                cursor.close();
            }
        }
    }

    private Point getImageSize(String imagePath) {
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inJustDecodeBounds = true;
        BitmapFactory.decodeFile(imagePath, options);
        return new Point(options.outWidth, options.outHeight);
    }

    private void handleMediaRowData(String data, long dateTaken, int width, int height) {
        if (checkScreenShot(data, dateTaken, width, height)) {
            Log.d(TAG, "ScreenShot: path = " + data + "; size = " + width + " * " + height
                    + "; date = " + dateTaken);
            if (mListener != null && !checkCallback(data)) {
                mListener.onShot(data);
            }
        } else {
            Log.w(TAG, "Media content changed, but not screenshot: path = " + data
                    + "; size = " + width + " * " + height + "; date = " + dateTaken);
        }
    }

    private boolean checkScreenShot(String data, long dateTaken, int width, int height) {
        if (dateTaken < mStartListenTime || (System.currentTimeMillis() - dateTaken) > 10 * 1000) {
            return false;
        }

        if (sScreenRealSize != null) {
            if (!((width <= sScreenRealSize.x && height <= sScreenRealSize.y)
                    || (height <= sScreenRealSize.x && width <= sScreenRealSize.y))) {
                return false;
            }
        }

        if (TextUtils.isEmpty(data)) {
            return false;
        }
        data = data.toLowerCase();
        for (String keyWork : KEYWORDS) {
            if (data.contains(keyWork)) {
                return true;
            }
        }

        return false;
    }

    private boolean checkCallback(String imagePath) {
        if (sHasCallbackPaths.contains(imagePath)) {
            Log.d(TAG, "ScreenShot: imgPath has done"
                    + "; imagePath = " + imagePath);
            return true;
        }
        if (sHasCallbackPaths.size() >= 20) {
            for (int i = 0; i < 5; i++) {
                sHasCallbackPaths.remove(0);
            }
        }
        sHasCallbackPaths.add(imagePath);
        return false;
    }

    private Point getRealScreenSize() {
        Point screenSize = null;
        try {
            screenSize = new Point();
            WindowManager windowManager = (WindowManager) mContext.getSystemService(Context.WINDOW_SERVICE);
            Display defaultDisplay = windowManager.getDefaultDisplay();
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
                defaultDisplay.getRealSize(screenSize);
            } else {
                try {
                    Method mGetRawW = Display.class.getMethod("getRawWidth");
                    Method mGetRawH = Display.class.getMethod("getRawHeight");
                    screenSize.set(
                            (Integer) mGetRawW.invoke(defaultDisplay),
                            (Integer) mGetRawH.invoke(defaultDisplay)
                    );
                } catch (Exception e) {
                    screenSize.set(defaultDisplay.getWidth(), defaultDisplay.getHeight());
                    e.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return screenSize;
    }

//    public Bitmap createScreenShotBitmap(Context context, String screenFilePath) {
//
//        View v = LayoutInflater.from(context).inflate(R.layout.share_screenshot_layout, null);
//        ImageView iv = (ImageView) v.findViewById(R.id.iv);
//        Bitmap bitmap = BitmapFactory.decodeFile(screenFilePath);
//        iv.setImageBitmap(bitmap);
//
//        //整体布局
//        Point point = getRealScreenSize();
//        v.measure(View.MeasureSpec.makeMeasureSpec(point.x, View.MeasureSpec.EXACTLY),
//                View.MeasureSpec.makeMeasureSpec(point.y, View.MeasureSpec.EXACTLY));
//
//        v.layout(0, 0, point.x, point.y);
//
////        Bitmap result = Bitmap.createBitmap(v.getWidth(), v.getHeight(), Bitmap.Config.RGB_565);
//        Bitmap result = Bitmap.createBitmap(v.getWidth(), v.getHeight() + dp2px(context, 140), Bitmap.Config.ARGB_8888);
//        Canvas c = new Canvas(result);
//        c.drawColor(Color.WHITE);
//        // Draw view to canvas
//        v.draw(c);
//
//        return result;
//    }
//
//    private int dp2px(Context ctx, float dp) {
//        float scale = ctx.getResources().getDisplayMetrics().density;
//        return (int) (dp * scale + 0.5f);
//    }

    public void setListener(OnScreenShotListener listener) {
        mListener = listener;
    }

    public interface OnScreenShotListener {
        void onShot(String imagePath);
    }

    private static void assertInMainThread() {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            StackTraceElement[] elements = Thread.currentThread().getStackTrace();
            String methodMsg = null;
            if (elements != null && elements.length >= 4) {
                methodMsg = elements[3].toString();
            }
            throw new IllegalStateException("Call the method must be in main thread: " + methodMsg);
        }
    }

    private class MediaContentObserver extends ContentObserver {

        private Uri mContentUri;

        public MediaContentObserver(Uri contentUri, Handler handler) {
            super(handler);
            mContentUri = contentUri;
        }

        @Override
        public void onChange(boolean selfChange) {
            super.onChange(selfChange);
            handleMediaContentChange(mContentUri);
        }
    }
}
