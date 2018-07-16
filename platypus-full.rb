require 'formula'

class PlatypusFull < Formula
  url 'https://github.com/sveinbjornt/Platypus/raw/master/Releases/platypus4.8.src.zip'
  version '4.8'
  sha256 '97138ae643ffb9f0c501e0e8b4d10aba9473f7193f6a0bcc4931685b05ab067f'
  head 'git://github.com/sveinbjornt/Platypus.git'
  homepage 'http://www.sveinbjorn.org/platypus'

  def patches
    DATA
  end
  
  def install
    if File.exists? 'Platypus ' + version + ' Source/Platypus.xcodeproj' then
      mv 'Platypus ' + version + ' Source', 'src'
      chdir 'src'
    end 

    # Fix paths
    inreplace ["Common.h", "CommandLineTool/platypus.1"] do |s|
      s.gsub! "/usr/local", prefix
    end
    
    xcb_args = [ "-configuration", "Deployment", "BUILD_PRODUCTS_DIR=build", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build", "MACOSX_DEPLOYMENT_TARGET=10.6", "GCC_VERSION=com.apple.compilers.llvm.clang.1_0", "GCC_ENABLE_OBJC_EXCEPTIONS=YES" ]
    if MacOS.version >= :mavericks then
  	  xcb_args << "SDKROOT=macosx10.8" 
    else
  	  xcb_args << "SDKROOT=" 
    end

    # Build main command-line binary, we don't care about the App
    system "xcodebuild", "-target", "platypus", *xcb_args

    # Build application sub-binary needed by command-line utility
    system "xcodebuild", "-target", "ScriptExec", *xcb_args

    # Build App
    system "xcodebuild", "-target", "Platypus", *xcb_args

    # Install binary and man page
    mv "build/Deployment/platypus_clt", "build/Deployment/platypus"
    bin.install "build/Deployment/platypus"

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
diff --git a/Platypus 4.8 Source/Platypus.xcodeproj/project.pbxproj b/Platypus 4.8 Source/Platypus.xcodeproj/project.pbxproj
index 8f9b6bd..b55f978 100755
--- a/Platypus 4.8 Source/Platypus.xcodeproj/project.pbxproj	
+++ b/Platypus 4.8 Source/Platypus.xcodeproj/project.pbxproj	
@@ -183,8 +183,8 @@
 		F4AF785C14D1E5F200544C1B /* STDragWebView.m */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.c.objc; name = STDragWebView.m; path = Shared/STDragWebView.m; sourceTree = "<group>"; };
 		F4B5DE3F14919FF500C43901 /* PlatypusUtility.h */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.c.h; name = PlatypusUtility.h; path = Shared/PlatypusUtility.h; sourceTree = "<group>"; };
 		F4B5DE4014919FF500C43901 /* PlatypusUtility.m */ = {isa = PBXFileReference; fileEncoding = 4; lastKnownFileType = sourcecode.c.objc; name = PlatypusUtility.m; path = Shared/PlatypusUtility.m; sourceTree = "<group>"; };
-		F4BABD75178A47E5003BA0FF /* platypus_clt */ = {isa = PBXFileReference; lastKnownFileType = "compiled.mach-o.executable"; name = platypus_clt; path = BuildData/Platypus/Build/Products/Development/platypus_clt; sourceTree = "<group>"; };
-		F4BCAAEC178DEDC2004ADD86 /* ScriptExec */ = {isa = PBXFileReference; lastKnownFileType = "compiled.mach-o.executable"; name = ScriptExec; path = BuildData/Platypus/Build/Products/Development/ScriptExec.app/Contents/MacOS/ScriptExec; sourceTree = "<group>"; };
+		F4BABD75178A47E5003BA0FF /* platypus_clt */ = {isa = PBXFileReference; lastKnownFileType = "compiled.mach-o.executable"; name = platypus_clt; path = "$(BUILT_PRODUCTS_DIR)/platypus_clt"; sourceTree = "<group>"; };
+		F4BCAAEC178DEDC2004ADD86 /* ScriptExec */ = {isa = PBXFileReference; lastKnownFileType = "compiled.mach-o.executable"; name = ScriptExec; path = "$(BUILT_PRODUCTS_DIR)/ScriptExec.app/Contents/MacOS/ScriptExec"; sourceTree = "<group>"; };
		F4BDABD50FD9A7CC00328FDD /* PlatypusScriptFile.icns */ = {isa = PBXFileReference; lastKnownFileType = image.icns; path = PlatypusScriptFile.icns; sourceTree = "<group>"; };
		F4BDABD60FD9A7CC00328FDD /* PlatypusProfile.icns */ = {isa = PBXFileReference; lastKnownFileType = image.icns; path = PlatypusProfile.icns; sourceTree = "<group>"; };
		F4C8B455124C450C00397392 /* Platypus.xib */ = {isa = PBXFileReference; lastKnownFileType = file.xib; name = Platypus.xib; path = PlatypusApplication/Platypus.xib; sourceTree = "<group>"; };
