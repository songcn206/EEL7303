@echo OFF
@rem ----------------------------------------------------------------
@rem
@rem   cdsvitool [-title title... --] [-c lineno] [-R] filepath
@rem   
@rem ----------------------------------------------------------------

@rem   Silently discard title arguments since mks vi resets win title
if not "%1" == "-title" goto pastTitle
:eatTitle
    shift
    if not "%1" == "--" goto eatTitle
    shift
:pastTitle

@rem Unfortunately $* is not affected by shift(s)
vi %1 %2 %3 %4 %5 %6 %7 %8 %9
