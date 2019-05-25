/* This rule file allows messages to be selectively turned off within
   the skill file being checked e.g. 

   ; beginning of file being checked
   euRepIgnore('(HI2IPC_1 HI2IPC_2 ...))

   ; file contents

   euRepUnignore('(HI2IPC_1 HI2IPC_2 ...))
   ; end of file being checked

*/

; 10/16/98 <wu> adapted from loadrules.il/skOnlyLoadsInStack()
; A top-level form is defined as anything whose outer context consists
; of only load/loadi/include forms (or nothing).

(define (skIsTopLevelForm)
  (forall formlist (cdr skFormStack)  
    (memq (skFormlistFunc formlist) '(load loadi include))
  )
)

SK_RULE( (euRepIgnore euRepUnignore)
	(skIsTopLevelForm)		; do this for top-level forms only
  	eval((car SK_FORM(1)))
)

;; 9/10/99 <michaelc> PCR 269540
(SK_RULE SK_CONTROL skDisableMessageBlock
  t
  (let ((args (SK_ARGS)) messages)
       ;-----------------------------------------------------------------
       ; Filter the message/message list to just be those not ignored
       ; already
       ;-----------------------------------------------------------------
       (setq messages 
	     (setof message 
		    (if (listp (car args)) (car args) (ncons (car args)))
		    (null (euRepIgnored message))
		    ))
       (euRepIgnore messages)
       (foreach map statement (cdr args)
		(SK_CHECK_FORM statement)
		)
       (euRepUnignore messages)
       )
)

(SK_RULE SK_CONTROL skEnableMessageBlock
  t
  (let ((args (SK_ARGS)) messages)
       ;-----------------------------------------------------------------
       ; Filter the message/message list to just be those ignored
       ; already
       ;-----------------------------------------------------------------
       (setq messages 
	     (setof message 
		    (if (listp (car args)) (car args) (ncons (car args)))
		    (euRepIgnored message)
		    ))
       (euRepUnignore messages)
       (foreach map statement (cdr args)
		(SK_CHECK_FORM statement)
		)
       (euRepIgnore messages)
       )
)


