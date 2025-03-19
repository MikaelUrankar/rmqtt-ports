--- rmqtt-conf/src/lib.rs	2023-11-10 15:58:50 UTC
+++ rmqtt-conf/src/lib.rs
@@ -60,6 +60,7 @@ impl Settings {
 impl Settings {
     fn new(opts: Options) -> Result<Self> {
         let mut builder = Config::builder()
+            .add_source(File::with_name("ETCDIR/rmqtt").required(false))
             .add_source(File::with_name("/etc/rmqtt/rmqtt").required(false))
             .add_source(File::with_name("/etc/rmqtt").required(false))
             .add_source(File::with_name("rmqtt").required(false))
