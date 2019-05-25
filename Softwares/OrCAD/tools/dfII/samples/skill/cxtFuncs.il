;(
; This is the control module for context building
; 32-Nov-90 E.S. Petrus; First cut
; 26-Apr-93 E.S. Petrus; 9304 release
; 
;---------------------------------------------------
; EXPORTED FUNCTIONS:
;   buildContext : used to build a context
;   getContext   : used to load a context
; 
;---------------------------------------------------
; 
; Constants
;    ilcDftSourceFileDir : directory name where Skill source
;       		   files reside
;    ilcDftDeliveryDir   : directory name where delivered
;                          context files are saved. 
;---------------------------------------------------

ilcDftSourceFileDir = "tools/dfII/pvt/etc/context"
ilcDftDeliveryDir   = "tools/dfII/etc/context"

(defun _parsePath (path)
(let (lpath)
        (cond (path
		lpath = parseString(path "/")
		(while (!rindex(car(lpath) "tools")) lpath = cdr(lpath))
		buildString(lpath "/")
		)
		(t nil))
))


_stacktrace = 10
setSkillPath(strcat(". ~ " prependInstallPath("local")))
(cond ((getd 'dbSetPath) (dbSetPath ". ~")))

;
; loadCxt --
;	Load a context and call its init function.
;
(defun loadCxt (cxt cxtPath)
  (let (f fullCxtPath)
      (if (equal (nindex cxtPath "tools") 1)
         (setq fullCxtPath (cdsGetInstPath (_iliAffirmCxtPath cxtPath)))
         (setq fullCxtPath (cdsGetToolsPath (_iliAffirmCxtPath cxtPath)))
      )

      (setq f (strcat fullCxtPath "/" cxt ".cxt")) 

      (cond
	((null (isFile f)) nil)
        ((null (loadContext f))
	    (printf "load of context %s failed\n" cxt))
	((null (callInitProc cxt))
	    (printf "init proc of context %s failed\n" cxt))
	(t (printf "Loading context %s\n" cxt))
     )
  )
)


;
; buildContext --
;	Build a new context, even if one exists.
;

(defun buildContext (cxt @rest targs)
   (let (cxtPath srcPath fullCxtPath)

        (cond ((car targs) (setq cxtPath (car targs)))
	      ((setq cxtPath (_iliGetActualCxtPath cxt)) t)
              (t (setq cxtPath ilcDftDeliveryDir)))
        (cond ((cadr targs) (setq srcPath (cadr targs)))
	      ((setq srcPath (_iliGetActualSrcPath cxt)) t)
              (t (setq srcPath (strcat ilcDftSourceFileDir "/" cxt))))

	cxtPath = (_iliAffirmCxtPath cxtPath)
	;; Keeping the cdsGetInstPath() call for backward compatibility
	;; purpose, as programs are doing away using a "tools" link to 
	;; locate files in the hierarchy.
	if( nindex(cxtPath "tools") == 1
	   ;; cdsGetInstPath() (from version SKILL06.50 and beyond) 
	   ;; is now invoking cdsGetToolsPath() to resolve "tools" 
	   ;; internally, if the first component of the given filepath 
	   ;; is "tools". 
           fullCxtPath = cdsGetInstPath(cxtPath)
           fullCxtPath = cdsGetToolsPath(cxtPath)
	)
	(unless (isDir fullCxtPath)
          (createDir fullCxtPath))

        (deleteFile (strcat fullCxtPath "/" cxt ".toc"))
        (deleteFile (strcat fullCxtPath "/" cxt ".aux"))
        (deleteFile (strcat fullCxtPath "/" cxt ".cxt"))
        (deleteFile (strcat fullCxtPath "/" cxt ".al"))
        (deleteFile (strcat fullCxtPath "/" cxt ".ini"))

        (updateContext cxt cxtPath srcPath)
        (updateAutoloads cxt cxtPath srcPath)
))

;
; updateContext --
;	If there is source and it is newer than the context,
;	then build a new context.  Otherwise if there is no source
;	use the existing context.
;
(defun updateContext (cxt cxtPath srcPath)
     (cond ((isDir (cdsGetInstPath srcPath)) 
            (let ((origVers (setSaveContextVersion (getNativeContextVersion))))
	        (errset (makeCapContext cxt cxtPath
				srcPath) t)
		(setSaveContextVersion origVers)
	    )
	 )
	   ((loadCxt cxt cxtPath) t)
	   (t (printf "Can't find context %s\n" cxt )))
)

(defun updateAutoloads (cxt cxtPath srcPath)
   (let (afile ifile fullSrcPath fullCxtPath)
       (if (equal (nindex srcPath "tools") 1)
	  (setq fullSrcPath (cdsGetInstPath srcPath))
	  (setq fullSrcPath (cdsGetToolsPath srcPath))
       )
       (setq afile (sprintf nil "%s/%s.al" fullSrcPath cxt)) 
       (setq ifile (sprintf nil "%s/%s.ini" fullSrcPath cxt))

       (if (equal (nindex cxtPath "tools") 1)
          (setq fullCxtPath (cdsGetInstPath cxtPath))
          (setq fullCxtPath (cdsGetToolsPath cxtPath))
       )
       (cond ((isFile ifile) 
	        (system (sprintf nil "cp %s %s" ifile fullCxtPath)))
             ((isFile afile) 
		(system (sprintf nil "cp %s %s" afile fullCxtPath)))
	   (t t))
))

;
; getContext --
;	Load the context if it exists, otherwise build it.
;


(defun getContext (cxt @rest targs)
   (let (cxtPath srcPath) 
        (cond ((car targs) (setq cxtPath (car targs)))
	      ((setq cxtPath (_iliGetActualCxtPath cxt)) t)
              (t (setq cxtPath ilcDftDeliveryDir)))
        (cond ((cadr targs) (setq srcPath (cadr targs)))
	      ((setq srcPath (_iliGetActualSrcPath cxt)) t)
              (t (setq srcPath (strcat ilcDftSourceFileDir "/" cxt))))

	cxtPath = (_iliAffirmCxtPath cxtPath)
        (cond ((loadCxt cxt cxtPath) t)
	      ((isDir cxt 
		  (if (equal (nindex srcPath "tools") 1)
			(cdsGetInstPath srcPath)
		        (cdsGetToolsPath srcPath)
		  ))
                  (let ((origVers (setSaveContextVersion (getNativeContextVersion))))
	              (errset (makeCapContext cxt cxtPath
				srcPath) t)
		      (setSaveContextVersion origVers)
	          )
	      )
         (t (printf "Can't get context %s\n" cxt) 
	    ))
))

(sstatus trapDefs ilcDftDeliveryDir)
(sstatus lazyComp nil)
