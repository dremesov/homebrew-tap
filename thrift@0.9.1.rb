class ThriftAT091 < Formula
  desc "Framework for scalable cross-language services development"
  homepage "https://thrift.apache.org"
  url "https://archive.apache.org/dist/thrift/0.9.1/thrift-0.9.1.tar.gz"
  sha256 "ac175080c8cac567b0331e394f23ac306472c071628396db2850cb00c41b0017"

  keg_only :versioned_formula

  option "with-haskell", "Install Haskell binding"
  option "with-erlang", "Install Erlang binding"
  option "with-java", "Install Java binding"
  option "with-perl", "Install Perl binding"
  option "with-php", "Install Php binding"

  deprecated_option "with-python" => "with-python@2"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "python@2" => :optional

  if build.with? "java"
    depends_on "ant" => :build
    depends_on :java => "1.8"
  end

  patch :DATA

  def install
    args = ["--without-ruby", "--without-tests", "--without-php_extension"]

    args << "--without-python" if build.without? "python@2"
    args << "--without-haskell" if build.without? "haskell"
    args << "--without-java" if build.without? "java"
    args << "--without-perl" if build.without? "perl"
    args << "--without-php" if build.without? "php"
    args << "--without-erlang" if build.without? "erlang"

    ENV.cxx11 if MacOS.version >= :mavericks && ENV.compiler == :clang

    # Don't install extensions to /usr
    ENV["PY_PREFIX"] = prefix
    ENV["PHP_PREFIX"] = prefix
    ENV["JAVA_PREFIX"] = pkgshare/"java"

    # configure's version check breaks on ant >1.10 so just override it. This
    # doesn't need guarding because of the --without-java flag used above.
    inreplace "configure", 'ANT=""', "ANT=\"#{Formula["ant"].opt_bin}/ant\""

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}",
                          *args
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_match "Thrift", shell_output("#{bin}/thrift --version")
  end
end

__END__
diff --git -r a/compiler b/compiler
index 5b91a0a..93bc62d 100644
--- a/compiler/cpp/src/thrifty.yy
+++ b/compiler/cpp/src/thrifty.yy
@@ -661,7 +661,7 @@ ConstValue:
       $$ = new t_const_value();
       $$->set_integer($1);
       if (!g_allow_64bit_consts && ($1 < INT32_MIN || $1 > INT32_MAX)) {
-        pwarning(1, "64-bit constant \"%"PRIi64"\" may not work in all languages.\n", $1);
+        pwarning(1, "64-bit constant \"%" PRIi64 "\" may not work in all languages.\n", $1);
       }
     }
 | tok_dub_constant
@@ -968,7 +968,7 @@ FieldIdentifier:
              * warn if the user-specified negative value isn't what
              * thrift would have auto-assigned.
              */
-            pwarning(1, "Nonpositive field key (%"PRIi64") differs from what would be "
+            pwarning(1, "Nonpositive field key (%" PRIi64 ") differs from what would be "
                      "auto-assigned by thrift (%d).\n", $1, y_field_val);
           }
           /*
@@ -979,7 +979,7 @@ FieldIdentifier:
           $$.value = $1;
           $$.auto_assigned = false;
         } else {
-          pwarning(1, "Nonpositive value (%"PRIi64") not allowed as a field key.\n",
+          pwarning(1, "Nonpositive value (%" PRIi64 ") not allowed as a field key.\n",
                    $1);
           $$.value = y_field_val--;
           $$.auto_assigned = true;
diff --git a/compiler/cpp/src/generate/t_java_generator.cc b/compiler/cpp/src/generate/t_java_generator.cc
index e443dc0..7e4d954 100644
--- a/compiler/cpp/src/generate/t_java_generator.cc
+++ b/compiler/cpp/src/generate/t_java_generator.cc
@@ -2827,7 +2827,7 @@ void t_java_generator::generate_process_async_function(t_service* tservice,
      bool first = true;
      if (xceptions.size() > 0) {
     	 for (x_iter = xceptions.begin(); x_iter != xceptions.end(); ++x_iter) {
-    		 first ? first = false : indent(f_service_) << "else ";
+    		 first ? first = false : ((indent(f_service_) << "else "), true);
     		 indent(f_service_) << "if (e instanceof " << type_name((*x_iter)->get_type(), false, false)<<") {" << endl;
     		 indent(f_service_) << indent() << "result." << (*x_iter)->get_name() << " = (" << type_name((*x_iter)->get_type(), false, false) << ") e;" << endl;
     	  	 indent(f_service_) << indent() << "result.set" << get_cap_name((*x_iter)->get_name()) << get_cap_name("isSet") << "(true);" << endl;
diff --git a/compiler/cpp/src/generate/t_rb_generator.cc b/compiler/cpp/src/generate/t_rb_generator.cc
index 082f316..cdcafd2 100644
--- a/compiler/cpp/src/generate/t_rb_generator.cc
+++ b/compiler/cpp/src/generate/t_rb_generator.cc
@@ -363,7 +363,7 @@ void t_rb_generator::generate_enum(t_enum* tenum) {
   for(c_iter = constants.begin(); c_iter != constants.end(); ++c_iter) {
     // Populate the hash
     int value = (*c_iter)->get_value();
-    first ? first = false : f_types_ << ", ";
+    first ? first = false : ((f_types_ << ", "), true);
     f_types_ << value << " => \"" << capitalize((*c_iter)->get_name()) << "\"";
   }
   f_types_ << "}" << endl;
@@ -373,7 +373,7 @@ void t_rb_generator::generate_enum(t_enum* tenum) {
   first = true;
   for (c_iter = constants.begin(); c_iter != constants.end(); ++c_iter) {
     // Populate the set
-    first ? first = false : f_types_ << ", ";
+    first ? first = false : ((f_types_ << ", "), true);
     f_types_ << capitalize((*c_iter)->get_name());
   }
   f_types_ << "]).freeze" << endl;
diff --git a/tutorial/cpp/CppClient.cpp b/tutorial/cpp/CppClient.cpp
index ba71caa..a7f1de8 100644
--- a/tutorial/cpp/CppClient.cpp
+++ b/tutorial/cpp/CppClient.cpp
@@ -27,7 +27,6 @@
 
 #include "../gen-cpp/Calculator.h"
 
-using namespace std;
 using namespace apache::thrift;
 using namespace apache::thrift::protocol;
 using namespace apache::thrift::transport;
@@ -35,12 +34,10 @@ using namespace apache::thrift::transport;
 using namespace tutorial;
 using namespace shared;
 
-using namespace boost;
-
 int main(int argc, char** argv) {
-  shared_ptr<TTransport> socket(new TSocket("localhost", 9090));
-  shared_ptr<TTransport> transport(new TBufferedTransport(socket));
-  shared_ptr<TProtocol> protocol(new TBinaryProtocol(transport));
+  boost::shared_ptr<TTransport> socket(new TSocket("localhost", 9090));
+  boost::shared_ptr<TTransport> transport(new TBufferedTransport(socket));
+  boost::shared_ptr<TProtocol> protocol(new TBinaryProtocol(transport));
   CalculatorClient client(protocol);
 
   try {
diff --git a/tutorial/cpp/CppServer.cpp b/tutorial/cpp/CppServer.cpp
index d0dbad9..3345070 100644
--- a/tutorial/cpp/CppServer.cpp
+++ b/tutorial/cpp/CppServer.cpp
@@ -32,7 +32,6 @@
 
 #include "../gen-cpp/Calculator.h"
 
-using namespace std;
 using namespace apache::thrift;
 using namespace apache::thrift::protocol;
 using namespace apache::thrift::transport;
@@ -41,8 +40,6 @@ using namespace apache::thrift::server;
 using namespace tutorial;
 using namespace shared;
 
-using namespace boost;
-
 class CalculatorHandler : public CalculatorIf {
  public:
   CalculatorHandler() {}
@@ -107,17 +104,17 @@ class CalculatorHandler : public CalculatorIf {
   }
 
 protected:
-  map<int32_t, SharedStruct> log;
+  std::map<int32_t, SharedStruct> log;
 
 };
 
 int main(int argc, char **argv) {
 
-  shared_ptr<TProtocolFactory> protocolFactory(new TBinaryProtocolFactory());
-  shared_ptr<CalculatorHandler> handler(new CalculatorHandler());
-  shared_ptr<TProcessor> processor(new CalculatorProcessor(handler));
-  shared_ptr<TServerTransport> serverTransport(new TServerSocket(9090));
-  shared_ptr<TTransportFactory> transportFactory(new TBufferedTransportFactory());
+  boost::shared_ptr<TProtocolFactory> protocolFactory(new TBinaryProtocolFactory());
+  boost::shared_ptr<CalculatorHandler> handler(new CalculatorHandler());
+  boost::shared_ptr<TProcessor> processor(new CalculatorProcessor(handler));
+  boost::shared_ptr<TServerTransport> serverTransport(new TServerSocket(9090));
+  boost::shared_ptr<TTransportFactory> transportFactory(new TBufferedTransportFactory());
 
   TSimpleServer server(processor,
                        serverTransport,
