;;
;; Nukefile for NuSQLite
;;
;; Commands:
;;	nuke 		- builds NuSQLite as a framework
;;	nuke test	- runs the unit tests in the NuTests directory
;;	nuke install	- installs NuSQLite in /Library/Frameworks
;;	nuke clean	- removes build artifacts
;;	nuke clobber	- removes build artifacts and NuSQLite.framework
;;
;; The "nuke" build tool is installed with Nu (http://programming.nu)
;;

;; the @variables below are instance variables of a NukeProject.
;; for details, see tools/nuke in the Nu source distribution.

;; source files
(set @m_files     (filelist "^objc/.*.m$"))
(set @c_files     (filelist "^c/.*.c$"))

(set SYSTEM ((NSString stringWithShellCommand:"uname") chomp))

(case SYSTEM
      ("Darwin"
               (set @arch (list "x86_64" "i386"))
               (set @cflags "-g -std=gnu99")
               (set @ldflags "-framework Foundation"))
      ("Linux"
              (set @arch (list "i386"))
              (set gnustep_flags ((NSString stringWithShellCommand:"gnustep-config --objc-flags") chomp))
              (set gnustep_libs ((NSString stringWithShellCommand:"gnustep-config --base-libs") chomp))
              (set @cflags "-g -std=gnu99 -DLINUX -I/usr/local/include #{gnustep_flags}")
              (set @ldflags "#{gnustep_libs}"))
      (else nil))

(@cflags appendString:" -DSQLITE_ENABLE_RTREE=1")
(@cflags appendString:" -DSQLITE_ENABLE_FTS3=1")

;; framework description
(set @framework "NuSQLite")
(set @framework_identifier   "nu.programming.sqlite")
(set @framework_creator_code "????")


(compilation-tasks)
(framework-tasks)

(task "clobber" => "clean" is
      (SH "rm -rf #{@framework_dir}")) ;; @framework_dir is defined by the nuke framework-tasks macro

(task "default" => "framework")

