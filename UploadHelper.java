import android.graphics.Bitmap;
import com.cloudinary.android.MediaManager;
import com.cloudinary.android.callback.ErrorInfo;
import com.cloudinary.android.callback.UploadCallback;
import java.io.ByteArrayOutputStream;
import java.util.Map;

public class UploadHelper {

    public interface UploadListener {
        void onSuccess(String imageUrl);
        void onError(String error);
    }

    public static void uploadFaceImage(Bitmap bitmap, UploadListener listener) {
        Bitmap small = Bitmap.createScaledBitmap(bitmap, 300, 300, true);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        small.compress(Bitmap.CompressFormat.JPEG, 70, baos);
        byte[] imageBytes = baos.toByteArray();

        MediaManager.get().upload(imageBytes)
            .unsigned("facesign_unsigned") // preset yang kamu buat di Cloudinary
            .option("folder", "facesign")
            .callback(new UploadCallback() {
                @Override
                public void onStart(String requestId) {}
                @Override
                public void onProgress(String requestId, long bytes, long totalBytes) {}
                @Override
                public void onSuccess(String requestId, Map resultData) {
                    String imageUrl = resultData.get("secure_url").toString();
                    listener.onSuccess(imageUrl);
                }
                @Override
                public void onError(String requestId, ErrorInfo error) {
                    listener.onError(error.getDescription());
                }
                @Override
                public void onReschedule(String requestId, ErrorInfo error) {}
            })
            .dispatch();
    }
}
