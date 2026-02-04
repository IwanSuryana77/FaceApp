public class MyApp extends Application {
    @Override
    public void onCreate() {
        super.onCreate();

        Map<String, Object> config = new HashMap<>();
        config.put("dv8zwl76d", "facesign_unsigned");

        MediaManager.init(this, config);
    }
}

// public class MyApp extends Application {
//     @Override
//     public void onCreate() {
//         super.onCreate();

//         Map<String, Object> config = new HashMap<>();
//         config.put("cloud_name", "facesign123"); // ganti dengan punyamu

//         MediaManager.init(this, config);
//     }
// }
