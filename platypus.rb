require 'formula'

class Platypus < Formula
  url 'https://github.com/sveinbjornt/Platypus/raw/master/Releases/platypus4.7.src.zip'
  version '4.7'
  sha1 '87b959b96df9221caacccba3e843558d6800ebec'
  head 'git://github.com/sveinbjornt/Platypus.git'
  homepage 'http://www.sveinbjorn.org/platypus'

  def patches
    DATA
  end

  def install
    if File.exists? 'Platypus ' + version + ' Source Code/Platypus.xcodeproj' then
      mv 'Platypus ' + version + ' Source Code', 'src'
      chdir 'src'
    end 

    # Fix paths
    inreplace ["Common.h", "CommandLineTool/platypus.1"] do |s|
      s.gsub! "/usr/local", prefix
    end
    
    # Build main command-line binary, we don't care about the App
    system "xcodebuild", "-target", "platypus", "-configuration", "Deployment", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build", "SDKROOT=", "MACOSX_DEPLOYMENT_TARGET=10.6", "GCC_VERSION=com.apple.compilers.llvm.clang.1_0", "GCC_ENABLE_OBJC_EXCEPTIONS=YES"

    # Build application sub-binary needed by command-line utility
    system "xcodebuild", "-target", "ScriptExec", "-configuration", "Deployment", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build", "SDKROOT=", "MACOSX_DEPLOYMENT_TARGET=10.6", "GCC_VERSION=com.apple.compilers.llvm.clang.1_0", "GCC_ENABLE_OBJC_EXCEPTIONS=YES"

    # Build App
    system "xcodebuild", "-target", "Platypus", "-configuration", "Deployment", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build", "SDKROOT=", "MACOSX_DEPLOYMENT_TARGET=10.6", "GCC_VERSION=com.apple.compilers.llvm.clang.1_0", "GCC_ENABLE_OBJC_EXCEPTIONS=YES"

    # Install binary and man page
    mv "build/Deployment/platypus_clt", "build/Deployment/platypus"
    bin.install "build/Deployment/platypus"

    rm_r 'build/Deployment/Platypus.app/Contents/Resources/ScriptExec.app'
    cp 'build/Deployment/ScriptExec.app/Contents/MacOS/ScriptExec', 'build/Deployment/Platypus.app/Contents/Resources'
    prefix.install "build/Deployment/Platypus.app"

    Dir.chdir('CommandLineTool') do
      man1.install "platypus.1"
    end

    # Install sub-binary parts to share
    Dir.chdir('build/Deployment/ScriptExec.app/Contents') do
      (share + 'platypus').install "MacOS/ScriptExec"
      (share + 'platypus/MainMenu.nib').install "Resources/MainMenu.nib/keyedobjects.nib"
    end

    # Install icons to share
    (share + 'platypus').install 'Icons/PlatypusAppIcon.icns'

    # Write version info to share
    (share + 'platypus/Version').write version
  end
end

__END__
diff --git a/Platypus 4.7 Source Code/Platypus.xcodeproj/project.pbxproj b/Platypus 4.7 Source Code/Platypus.xcodeproj/project.pbxproj
index 41883db..b68445e 100755
--- a/Platypus 4.7 Source Code/Platypus.xcodeproj/project.pbxproj	
+++ b/Platypus 4.7 Source Code/Platypus.xcodeproj/project.pbxproj	
@@ -7,10 +7,10 @@
 	objects = {
 
 /* Begin PBXBuildFile section */
+		0A0DA5DD15B9CD7800259C6E /* ScriptExec.app in Resources */ = {isa = PBXBuildFile; fileRef = F48B774111F7661C00351575 /* ScriptExec.app */; };
+		0A0DA5DE15B9CD7800259C6E /* platypus_clt in Resources */ = {isa = PBXBuildFile; fileRef = F4E1F6FC11F758FB007EE2E3 /* platypus_clt */; };
 		8D11072D0486CEB800E47090 /* main.m in Sources */ = {isa = PBXBuildFile; fileRef = 29B97316FDCFA39411CA2CEA /* main.m */; settings = {ATTRIBUTES = (); }; };
 		8D11072F0486CEB800E47090 /* Cocoa.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = 1058C7A1FEA54F0111CA2CBB /* Cocoa.framework */; };
-		F40706CB14DC72FE00BF4DD5 /* ScriptExec in Resources */ = {isa = PBXBuildFile; fileRef = F40706CA14DC72FE00BF4DD5 /* ScriptExec */; };
-		F40706CE14DC730600BF4DD5 /* platypus_clt in Resources */ = {isa = PBXBuildFile; fileRef = F40706CD14DC730600BF4DD5 /* platypus_clt */; };
 		F40F756013C266AE00197499 /* ShellCommandController.m in Sources */ = {isa = PBXBuildFile; fileRef = F40F755F13C266AE00197499 /* ShellCommandController.m */; };
 		F44402CC1493EED300261B21 /* ScriptAnalyser.m in Sources */ = {isa = PBXBuildFile; fileRef = F482949C122C128200094A1B /* ScriptAnalyser.m */; };
 		F445EA7714FAB61900DCCDB3 /* Sparkle.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = F445EA7614FAB61900DCCDB3 /* Sparkle.framework */; };
@@ -222,7 +222,7 @@
 		F4DC074F11F629A40043764E /* PlatypusDocumentation.html */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = text.html.documentation; path = PlatypusDocumentation.html; sourceTree = "<group>"; };
 		F4DC075011F629A40043764E /* Readme.html */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = text.html.documentation; path = Readme.html; sourceTree = "<group>"; };
 		F4E1F47C11F756D9007EE2E3 /* Security.framework */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = Security.framework; path = /System/Library/Frameworks/Security.framework; sourceTree = "<absolute>"; };
-		F4E1F6FC11F758FB007EE2E3 /* platypus */ = {isa = PBXFileReference; explicitFileType = "compiled.mach-o.executable"; includeInIndex = 0; name = platypus; path = platypus_clt; sourceTree = BUILT_PRODUCTS_DIR; };
+		F4E1F6FC11F758FB007EE2E3 /* platypus_clt */ = {isa = PBXFileReference; explicitFileType = "compiled.mach-o.executable"; includeInIndex = 0; path = platypus_clt; sourceTree = BUILT_PRODUCTS_DIR; };
 		F4ECE1A011F7746A000DB012 /* CHANGES.txt */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = text; path = CHANGES.txt; sourceTree = SOURCE_ROOT; };
 		F4ECE1A111F77471000DB012 /* TODO.txt */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = text; path = TODO.txt; sourceTree = SOURCE_ROOT; };
 		F4ED1E460CEC17920006636F /* Carbon.framework */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; name = Carbon.framework; path = /System/Library/Frameworks/Carbon.framework; sourceTree = "<absolute>"; };
@@ -324,7 +324,7 @@
 			isa = PBXGroup;
 			children = (
 				F48B774111F7661C00351575 /* ScriptExec.app */,
-				F4E1F6FC11F758FB007EE2E3 /* platypus */,
+				F4E1F6FC11F758FB007EE2E3 /* platypus_clt */,
 				8D1107320486CEB800E47090 /* Platypus.app */,
 			);
 			name = Products;
@@ -764,7 +764,7 @@
 			);
 			name = platypus;
 			productName = platypus;
-			productReference = F4E1F6FC11F758FB007EE2E3 /* platypus */;
+			productReference = F4E1F6FC11F758FB007EE2E3 /* platypus_clt */;
 			productType = "com.apple.product-type.tool";
 		};
 /* End PBXNativeTarget section */
@@ -802,6 +802,8 @@
 			isa = PBXResourcesBuildPhase;
 			buildActionMask = 2147483647;
 			files = (
+				0A0DA5DD15B9CD7800259C6E /* ScriptExec.app in Resources */,
+				0A0DA5DE15B9CD7800259C6E /* platypus_clt in Resources */,
 				F4BDABD70FD9A7CC00328FDD /* PlatypusScriptFile.icns in Resources */,
 				F4BDABD80FD9A7CC00328FDD /* PlatypusProfile.icns in Resources */,
 				F4DC074A11F629930043764E /* InstallCommandLineTool.sh in Resources */,
@@ -846,8 +848,6 @@
 				F4D656BA14C4BFD6003552F9 /* Tcl.png in Resources */,
 				F4D656BB14C4BFD6003552F9 /* Tcsh.png in Resources */,
 				F4D656BC14C4BFD6003552F9 /* Zsh.png in Resources */,
-				F40706CB14DC72FE00BF4DD5 /* ScriptExec in Resources */,
-				F40706CE14DC730600BF4DD5 /* platypus_clt in Resources */,
 				F4A36B9D14F2C8A70028A227 /* Csh.png in Resources */,
 				F4A36B9E14F2C8A70028A227 /* Ksh.png in Resources */,
 				F445EA7B14FAB93300DCCDB3 /* dsa_pub.pem in Resources */,

