## -*- tcl -*-
##
## Critcl-based C/PARAM implementation of the parsing
## expression grammar
##
##	PEG
##
## Generated from file	3_peg_itself
##            for user  aku
##
# # ## ### ##### ######## ############# #####################
## Requirements

package require Tcl 8.4
package require critcl
# @sak notprovided pt_parse_peg_c
package provide    pt_parse_peg_c 1

# Note: The implementation of the PARAM virtual machine
#       underlying the C/PARAM code used below is inlined
#       into the generated parser, allowing for direct access
#       and manipulation of the RDE state, instead of having
#       to dispatch through the Tcl interpreter.

# # ## ### ##### ######## ############# #####################
##

namespace eval ::pt::parse {
    # # ## ### ##### ######## ############# #####################
    ## Supporting code for the main command.

    catch {
	#critcl::cheaders -g
	#critcl::debug memory symbols
    }

    # # ## ### ###### ######## #############
    ## RDE runtime, inlined, and made static.

    # This is the C code for the RDE, i.e. the implementation
    # of pt::rde. Only the low-level engine is imported, the
    # Tcl interface layer is ignored.  This generated parser
    # provides its own layer for that.

    critcl::ccode {
	/* -*- c -*- */

	#include <string.h>
	#define SCOPE static

#line 1 "rde_critcl/util.h"

	#ifndef _RDE_UTIL_H
	#define _RDE_UTIL_H 1
	#ifndef SCOPE
	#define SCOPE
	#endif
	#define ALLOC(type)    (type *) ckalloc (sizeof (type))
	#define NALLOC(n,type) (type *) ckalloc ((n) * sizeof (type))
	#undef  RDE_DEBUG
	#define RDE_DEBUG 1
	#undef  RDE_TRACE
	#ifdef RDE_DEBUG
	#define STOPAFTER(x) { static int count = (x); count --; if (!count) { Tcl_Panic ("stop"); } }
	#define XSTR(x) #x
	#define STR(x) XSTR(x)
	#define RANGEOK(i,n) ((0 <= (i)) && (i < (n)))
	#define ASSERT(x,msg) if (!(x)) { Tcl_Panic (msg " (" #x "), in file " __FILE__ " @line " STR(__LINE__));}
	#define ASSERT_BOUNDS(i,n) ASSERT (RANGEOK(i,n),"array index out of bounds: " STR(i) " >= " STR(n))
	#else
	#define STOPAFTER(x)
	#define ASSERT(x,msg)
	#define ASSERT_BOUNDS(i,n)
	#endif
	#ifdef RDE_TRACE
	SCOPE void trace_enter (const char* fun);
	SCOPE void trace_return (const char *pat, ...);
	SCOPE void trace_printf (const char *pat, ...);
	#define ENTER(fun)          trace_enter (fun)
	#define RETURN(format,x)    trace_return (format,x) ; return x
	#define RETURNVOID          trace_return ("%s","(void)") ; return
	#define TRACE0(x)           trace_printf0 x
	#define TRACE(x)            trace_printf x
	#else
	#define ENTER(fun)
	#define RETURN(f,x) return x
	#define RETURNVOID  return
	#define TRACE0(x)
	#define TRACE(x)
	#endif
	#endif 
	

#line 1 "rde_critcl/stack.h"

	#ifndef _RDE_DS_STACK_H
	#define _RDE_DS_STACK_H 1
	typedef void (*RDE_STACK_CELL_FREE) (void* cell);
	typedef struct RDE_STACK_* RDE_STACK;
	static const int RDE_STACK_INITIAL_SIZE = 256;
	#endif 
	

#line 1 "rde_critcl/tc.h"

	#ifndef _RDE_DS_TC_H
	#define _RDE_DS_TC_H 1
	typedef struct RDE_TC_* RDE_TC;
	#endif 
	

#line 1 "rde_critcl/param.h"

	#ifndef _RDE_DS_PARAM_H
	#define _RDE_DS_PARAM_H 1
	typedef struct RDE_PARAM_* RDE_PARAM;
	typedef struct ERROR_STATE {
	    int       refCount;
	    long int  loc;
	    RDE_STACK msg; 
	} ERROR_STATE;
	typedef struct NC_STATE {
	    long int     CL;
	    long int     ST;
	    Tcl_Obj*     SV;
	    ERROR_STATE* ER;
	} NC_STATE;
	#endif 
	

#line 1 "rde_critcl/util.c"

	#ifdef RDE_TRACE
	typedef struct F_STACK {
	    const char*     str;
	    struct F_STACK* down;
	} F_STACK;
	static F_STACK* top   = 0;
	static int      level = 0;
	static void
	push (const char* str)
	{
	    F_STACK* new = ALLOC (F_STACK);
	    new->str = str;
	    new->down = top;
	    top = new;
	    level += 4;
	}
	static void
	pop (void)
	{
	    F_STACK* next = top->down;
	    level -= 4;
	    ckfree ((char*)top);
	    top = next;
	}
	static void
	indent (void)
	{
	    int i;
	    for (i = 0; i < level; i++) {
		fwrite(" ", 1, 1, stdout);
		fflush           (stdout);
	    }
	    if (top) {
		fwrite(top->str, 1, strlen(top->str), stdout);
		fflush                               (stdout);
	    }
	    fwrite(" ", 1, 1, stdout);
	    fflush           (stdout);
	}
	SCOPE void
	trace_enter (const char* fun)
	{
	    push (fun);
	    indent();
	    fwrite("ENTER\n", 1, 6, stdout);
	    fflush                 (stdout);
	}
	static char msg [1024*1024];
	SCOPE void
	trace_return (const char *pat, ...)
	{
	    int len;
	    va_list args;
	    indent();
	    fwrite("RETURN = ", 1, 9, stdout);
	    fflush                   (stdout);
	    va_start(args, pat);
	    len = vsprintf(msg, pat, args);
	    va_end(args);
	    msg[len++] = '\n';
	    msg[len] = '\0';
	    fwrite(msg, 1, len, stdout);
	    fflush             (stdout);
	    pop();
	}
	SCOPE void
	trace_printf (const char *pat, ...)
	{
	    int len;
	    va_list args;
	    indent();
	    va_start(args, pat);
	    len = vsprintf(msg, pat, args);
	    va_end(args);
	    msg[len++] = '\n';
	    msg[len] = '\0';
	    fwrite(msg, 1, len, stdout);
	    fflush             (stdout);
	}
	SCOPE void
	trace_printf0 (const char *pat, ...)
	{
	    int len;
	    va_list args;
	    va_start(args, pat);
	    len = vsprintf(msg, pat, args);
	    va_end(args);
	    msg[len++] = '\n';
	    msg[len] = '\0';
	    fwrite(msg, 1, len, stdout);
	    fflush             (stdout);
	}
	#endif
	

#line 1 "rde_critcl/stack.c"

	typedef struct RDE_STACK_ {
	    long int            max;   
	    long int            top;   
	    RDE_STACK_CELL_FREE freeCellProc; 
	    void**              cell;  
	} RDE_STACK_;
	
	SCOPE RDE_STACK
	rde_stack_new (RDE_STACK_CELL_FREE freeCellProc)
	{
	    RDE_STACK s = ALLOC (RDE_STACK_);
	    s->cell = NALLOC (RDE_STACK_INITIAL_SIZE, void*);
	    s->max  = RDE_STACK_INITIAL_SIZE;
	    s->top  = 0;
	    s->freeCellProc = freeCellProc;
	    return s;
	}
	SCOPE void
	rde_stack_del (RDE_STACK s)
	{
	    if (s->freeCellProc && s->top) {
		long int i;
		for (i=0; i < s->top; i++) {
		    ASSERT_BOUNDS(i,s->max);
		    s->freeCellProc ( s->cell [i] );
		}
	    }
	    ckfree ((char*) s->cell);
	    ckfree ((char*) s);
	}
	SCOPE void
	rde_stack_push (RDE_STACK s, void* item)
	{
	    if (s->top >= s->max) {
		long int new  = s->max ? (2 * s->max) : RDE_STACK_INITIAL_SIZE;
		void**   cell = (void**) ckrealloc ((char*) s->cell, new * sizeof(void*));
		ASSERT (cell,"Memory allocation failure for RDE stack");
		s->max  = new;
		s->cell = cell;
	    }
	    ASSERT_BOUNDS(s->top,s->max);
	    s->cell [s->top] = item;
	    s->top ++;
	}
	SCOPE void*
	rde_stack_top (RDE_STACK s)
	{
	    ASSERT_BOUNDS(s->top-1,s->max);
	    return s->cell [s->top - 1];
	}
	SCOPE void
	rde_stack_pop (RDE_STACK s, long int n)
	{
	    ASSERT (n >= 0, "Bad pop count");
	    if (n == 0) return;
	    if (s->freeCellProc) {
		while (n) {
		    s->top --;
		    ASSERT_BOUNDS(s->top,s->max);
		    s->freeCellProc ( s->cell [s->top] );
		    n --;
		}
	    } else {
		s->top -= n;
	    }
	}
	SCOPE void
	rde_stack_trim (RDE_STACK s, long int n)
	{
	    ASSERT (n >= 0, "Bad trimsize");
	    if (s->freeCellProc) {
		while (s->top > n) {
		    s->top --;
		    ASSERT_BOUNDS(s->top,s->max);
		    s->freeCellProc ( s->cell [s->top] );
		}
	    } else {
		s->top = n;
	    }
	}
	SCOPE void
	rde_stack_drop (RDE_STACK s, long int n)
	{
	    ASSERT (n >= 0, "Bad pop count");
	    if (n == 0) return;
	    s->top -= n;
	}
	SCOPE void
	rde_stack_move (RDE_STACK dst, RDE_STACK src)
	{
	    ASSERT (dst->freeCellProc == src->freeCellProc, "Ownership mismatch");
	    
	    while (src->top > 0) {
		src->top --;
		ASSERT_BOUNDS(src->top,src->max);
		rde_stack_push (dst, src->cell [src->top] );
	    }
	}
	SCOPE void
	rde_stack_get (RDE_STACK s, long int* cn, void*** cc)
	{
	    *cn = s->top;
	    *cc = s->cell;
	}
	SCOPE long int
	rde_stack_size (RDE_STACK s)
	{
	    return s->top;
	}
	

#line 1 "rde_critcl/tc.c"

	typedef struct RDE_TC_ {
	    int       max;   
	    int       num;   
	    char*     str;   
	    RDE_STACK off;   
	} RDE_TC_;
	
	SCOPE RDE_TC
	rde_tc_new (void)
	{
	    RDE_TC tc = ALLOC (RDE_TC_);
	    tc->max   = RDE_STACK_INITIAL_SIZE;
	    tc->num   = 0;
	    tc->str   = NALLOC (RDE_STACK_INITIAL_SIZE, char);
	    tc->off   = rde_stack_new (NULL);
	    return tc;
	}
	SCOPE void
	rde_tc_del (RDE_TC tc)
	{
	    rde_stack_del (tc->off);
	    ckfree (tc->str);
	    ckfree ((char*) tc);
	}
	SCOPE long int
	rde_tc_size (RDE_TC tc)
	{
	    return rde_stack_size (tc->off);
	}
	SCOPE void
	rde_tc_clear (RDE_TC tc)
	{
	    tc->num   = 0;
	    rde_stack_trim (tc->off,  0);
	}
	SCOPE char*
	rde_tc_append (RDE_TC tc, char* string, long int len)
	{
	    long int base = tc->num;
	    long int off  = tc->num;
	    char* ch;
	    int clen;
	    Tcl_UniChar uni;
	    if (len < 0) {
		len = strlen (ch);
	    }
	    
	    if ((tc->num + len) >= tc->max) {
		int   new = len + (tc->max ? (2 * tc->max) : RDE_STACK_INITIAL_SIZE);
		char* str = ckrealloc (tc->str, new * sizeof(char));
		ASSERT (str,"Memory allocation failure for token character array");
		tc->max = new;
		tc->str = str;
	    }
	    tc->num += len;
	    ASSERT_BOUNDS(tc->num,tc->max);
	    ASSERT_BOUNDS(off,tc->max);
	    ASSERT_BOUNDS(off+len-1,tc->max);
	    ASSERT_BOUNDS(off+len-1,tc->num);
	    memcpy (tc->str + off, string, len);
	    
	    ch = string;
	    while (ch < (string + len)) {
		ASSERT_BOUNDS(off,tc->num);
		rde_stack_push (tc->off,  (void*) off);
		clen = Tcl_UtfToUniChar (ch, &uni);
		off += clen;
		ch  += clen;
	    }
	    return tc->str + base;
	}
	SCOPE void
	rde_tc_get (RDE_TC tc, int at, char** ch, long int* len)
	{
	    long int  oc, off, top, end;
	    long int* ov;
	    rde_stack_get (tc->off, &oc, (void***) &ov);
	    ASSERT_BOUNDS(at,oc);
	    off = ov [at];
	    if ((at+1) == oc) {
		end = tc->num;
	    } else {
		end = ov [at+1];
	    }
	    TRACE (("rde_tc_get (RDE_TC %p, @ %d) => %d.[%d ... %d]/%d",tc,at,end-off,off,end-1,tc->num));
	    ASSERT_BOUNDS(off,tc->num);
	    ASSERT_BOUNDS(end-1,tc->num);
	    *ch = tc->str + off;
	    *len = end - off;
	}
	SCOPE void
	rde_tc_get_s (RDE_TC tc, int at, int last, char** ch, long int* len)
	{
	    long int  oc, off, top, end;
	    long int* ov;
	    rde_stack_get (tc->off, &oc, (void***) &ov);
	    ASSERT_BOUNDS(at,oc);
	    ASSERT_BOUNDS(last,oc);
	    off = ov [at];
	    if ((last+1) == oc) {
		end = tc->num;
	    } else {
		end = ov [last+1];
	    }
	    TRACE (("rde_tc_get_s (RDE_TC %p, @ %d .. %d) => %d.[%d ... %d]/%d",tc,at,last,end-off,off,end-1,tc->num));
	    ASSERT_BOUNDS(off,tc->num);
	    ASSERT_BOUNDS(end-1,tc->num);
	    *ch = tc->str + off;
	    *len = end - off;
	}
	

#line 1 "rde_critcl/param.c"

	typedef struct RDE_PARAM_ {
	    Tcl_Channel   IN;
	    Tcl_Obj*      readbuf;
	    char*         CC; 
	    long int      CC_len;
	    RDE_TC        TC;
	    long int      CL;
	    RDE_STACK     LS; 
	    ERROR_STATE*  ER;
	    RDE_STACK     ES; 
	    long int      ST;
	    Tcl_Obj*      SV;
	    Tcl_HashTable NC;
	    
	    RDE_STACK    ast  ; 
	    RDE_STACK    mark ; 
	    
	    long int numstr; 
	    char**  string;
	    
	    ClientData clientData;
	} RDE_PARAM_;
	typedef int (*UniCharClass) (int);
	typedef enum test_class_id {
	    tc_alnum,
	    tc_alpha,
	    tc_ascii,
	    tc_ddigit,
	    tc_digit,
	    tc_graph,
	    tc_lower,
	    tc_printable,
	    tc_punct,
	    tc_space,
	    tc_upper,
	    tc_wordchar,
	    tc_xdigit
	} test_class_id;
	static void ast_node_free    (void* n);
	static void error_state_free (void* es);
	static void error_set        (RDE_PARAM p, int s);
	static void nc_clear         (RDE_PARAM p);
	static int UniCharIsAscii    (int character);
	static int UniCharIsHexDigit (int character);
	static int UniCharIsDecDigit (int character);
	static void test_class (RDE_PARAM p, UniCharClass class, test_class_id id);
	static int  er_int_compare (const void* a, const void* b);
	#define SV_INIT(p)             \
	    p->SV = NULL; \
	    TRACE (("SV_INIT (%p => %p)", (p), (p)->SV))
	#define SV_SET(p,newsv)             \
	    if (((p)->SV) != (newsv)) { \
	        TRACE (("SV_CLEAR/set (%p => %p)", (p), (p)->SV)); \
	        if ((p)->SV) {                  \
		    Tcl_DecrRefCount ((p)->SV); \
	        }				    \
	        (p)->SV = (newsv);		    \
	        TRACE (("SV_SET       (%p => %p)", (p), (p)->SV)); \
	        if ((p)->SV) {                  \
		    Tcl_IncrRefCount ((p)->SV); \
	        } \
	    }
	#define SV_CLEAR(p)                 \
	    TRACE (("SV_CLEAR (%p => %p)", (p), (p)->SV)); \
	    if ((p)->SV) {                  \
		Tcl_DecrRefCount ((p)->SV); \
	    }				    \
	    (p)->SV = NULL
	#define ER_INIT(p)             \
	    p->ER = NULL; \
	    TRACE (("ER_INIT (%p => %p)", (p), (p)->ER))
	#define ER_CLEAR(p)             \
	    error_state_free ((p)->ER);	\
	    (p)->ER = NULL
	SCOPE RDE_PARAM
	rde_param_new (long int nstr, char** strings)
	{
	    RDE_PARAM p;
	    ENTER ("rde_param_new");
	    TRACE (("\tINT %d strings @ %p", nstr, strings));
	    p = ALLOC (RDE_PARAM_);
	    p->numstr = nstr;
	    p->string = strings;
	    p->readbuf = Tcl_NewObj ();
	    Tcl_IncrRefCount (p->readbuf);
	    TRACE (("\tTcl_Obj* readbuf %p used %d", p->readbuf,p->readbuf->refCount));
	    Tcl_InitHashTable (&p->NC, TCL_ONE_WORD_KEYS);
	    p->IN   = NULL;
	    p->CL   = -1;
	    p->ST   = 0;
	    ER_INIT (p);
	    SV_INIT (p);
	    p->CC   = NULL;
	    p->CC_len = 0;
	    p->TC   = rde_tc_new ();
	    p->ES   = rde_stack_new (error_state_free);
	    p->LS   = rde_stack_new (NULL);
	    p->ast  = rde_stack_new (ast_node_free);
	    p->mark = rde_stack_new (NULL);
	    RETURN ("%p", p);
	}
	SCOPE void 
	rde_param_del (RDE_PARAM p)
	{
	    ENTER ("rde_param_del");
	    TRACE (("RDE_PARAM %p",p));
	    ER_CLEAR (p);                 TRACE (("\ter_clear"));
	    SV_CLEAR (p);                 TRACE (("\tsv_clear"));
	    nc_clear (p);                 TRACE (("\tnc_clear"));
	    Tcl_DeleteHashTable (&p->NC); TRACE (("\tnc hashtable delete"));
	    rde_tc_del    (p->TC);        TRACE (("\ttc clear"));
	    rde_stack_del (p->ES);        TRACE (("\tes clear"));
	    rde_stack_del (p->LS);        TRACE (("\tls clear"));
	    rde_stack_del (p->ast);       TRACE (("\tast clear"));
	    rde_stack_del (p->mark);      TRACE (("\tmark clear"));
	    TRACE (("\tTcl_Obj* readbuf %p used %d", p->readbuf,p->readbuf->refCount));
	    Tcl_DecrRefCount (p->readbuf);
	    ckfree ((char*) p);
	    RETURNVOID;
	}
	SCOPE void 
	rde_param_reset (RDE_PARAM p, Tcl_Channel chan)
	{
	    ENTER ("rde_param_reset");
	    TRACE (("RDE_PARAM   %p",p));
	    TRACE (("Tcl_Channel %p",chan));
	    p->IN  = chan;
	    p->CL  = -1;
	    p->ST  = 0;
	    p->CC  = NULL;
	    p->CC_len = 0;
	    ER_CLEAR (p);
	    SV_CLEAR (p);
	    nc_clear (p);
	    rde_tc_clear   (p->TC);
	    rde_stack_trim (p->ES,   0);
	    rde_stack_trim (p->LS,   0);
	    rde_stack_trim (p->ast,  0);
	    rde_stack_trim (p->mark, 0);
	    TRACE (("\tTcl_Obj* readbuf %p used %d", p->readbuf,p->readbuf->refCount));
	    RETURNVOID;
	}
	SCOPE void
	rde_param_update_strings (RDE_PARAM p, long int nstr, char** strings)
	{
	    ENTER ("rde_param_update_strings");
	    TRACE (("RDE_PARAM %p", p));
	    TRACE (("INT       %d strings", nstr));
	    p->numstr = nstr;
	    p->string = strings;
	    RETURNVOID;
	}
	SCOPE void
	rde_param_data (RDE_PARAM p, char* buf, long int len)
	{
	    (void) rde_tc_append (p->TC, buf, len);
	}
	SCOPE void
	rde_param_clientdata (RDE_PARAM p, ClientData clientData)
	{
	    p->clientData = clientData;
	}
	static void
	nc_clear (RDE_PARAM p)
	{
	    Tcl_HashSearch hs;
	    Tcl_HashEntry* he;
	    Tcl_HashTable* tablePtr;
	    for(he = Tcl_FirstHashEntry(&p->NC, &hs);
		he != NULL;
		he = Tcl_FirstHashEntry(&p->NC, &hs)) {
		Tcl_HashSearch hsc;
		Tcl_HashEntry* hec;
		tablePtr = (Tcl_HashTable*) Tcl_GetHashValue (he);
		for(hec = Tcl_FirstHashEntry(tablePtr, &hsc);
		    hec != NULL;
		    hec = Tcl_NextHashEntry(&hsc)) {
		    NC_STATE* scs = Tcl_GetHashValue (hec);
		    error_state_free (scs->ER);
		    if (scs->SV) { Tcl_DecrRefCount (scs->SV); }
		    ckfree ((char*) scs);
		}
		Tcl_DeleteHashTable (tablePtr);
		ckfree ((char*) tablePtr);
		Tcl_DeleteHashEntry (he);
	    }
	}
	SCOPE ClientData
	rde_param_query_clientdata (RDE_PARAM p)
	{
	    return p->clientData;
	}
	SCOPE void
	rde_param_query_amark (RDE_PARAM p, long int* mc, long int** mv)
	{
	    rde_stack_get (p->mark, mc, (void***) mv);
	}
	SCOPE void
	rde_param_query_ast (RDE_PARAM p, long int* ac, Tcl_Obj*** av)
	{
	    rde_stack_get (p->ast, ac, (void***) av);
	}
	SCOPE const char*
	rde_param_query_in (RDE_PARAM p)
	{
	    return p->IN
		? Tcl_GetChannelName (p->IN)
		: "";
	}
	SCOPE const char*
	rde_param_query_cc (RDE_PARAM p, long int* len)
	{
	    *len = p->CC_len;
	    return p->CC;
	}
	SCOPE int
	rde_param_query_cl (RDE_PARAM p)
	{
	    return p->CL;
	}
	SCOPE const ERROR_STATE*
	rde_param_query_er (RDE_PARAM p)
	{
	    return p->ER;
	}
	SCOPE Tcl_Obj*
	rde_param_query_er_tcl (RDE_PARAM p, const ERROR_STATE* er)
	{
	    Tcl_Obj* res;
	    if (!er) {
		
		res = Tcl_NewStringObj ("", 0);
	    } else {
		Tcl_Obj* ov [2];
		Tcl_Obj** mov;
		long int  mc, i, j;
		long int* mv;
		int lastid;
		const char* msg;
		rde_stack_get (er->msg, &mc, (void***) &mv);
		
		qsort (mv, mc, sizeof (long int), er_int_compare);
		
		mov = NALLOC (mc, Tcl_Obj*);
		lastid = -1;
		for (i=0, j=0; i < mc; i++) {
		    ASSERT_BOUNDS (i,mc);
		    if (mv [i] == lastid) continue;
		    lastid = mv [i];
		    ASSERT_BOUNDS(mv[i],p->numstr);
		    msg = p->string [mv[i]]; 
		    ASSERT_BOUNDS (j,mc);
		    mov [j] = Tcl_NewStringObj (msg, -1);
		    j++;
		}
		
		ov [0] = Tcl_NewIntObj  (er->loc);
		ov [1] = Tcl_NewListObj (j, mov);
		res = Tcl_NewListObj (2, ov);
		ckfree ((char*) mov);
	    }
	    return res;
	}
	SCOPE void
	rde_param_query_es (RDE_PARAM p, long int* ec, ERROR_STATE*** ev)
	{
	    rde_stack_get (p->ES, ec, (void***) ev);
	}
	SCOPE void
	rde_param_query_ls (RDE_PARAM p, long int* lc, long int** lv)
	{
	    rde_stack_get (p->LS, lc, (void***) lv);
	}
	SCOPE Tcl_HashTable*
	rde_param_query_nc (RDE_PARAM p)
	{
	    return &p->NC;
	}
	SCOPE int
	rde_param_query_st (RDE_PARAM p)
	{
	    return p->ST;
	}
	SCOPE Tcl_Obj*
	rde_param_query_sv (RDE_PARAM p)
	{
	    TRACE (("SV_QUERY %p => (%p)", (p), (p)->SV)); \
	    return p->SV;
	}
	SCOPE long int
	rde_param_query_tc_size (RDE_PARAM p)
	{
	    return rde_tc_size (p->TC);
	}
	SCOPE void
	rde_param_query_tc_get_s (RDE_PARAM p, long int at, long int last, char** ch, long int* len)
	{
	    rde_tc_get_s (p->TC, at, last, ch, len);
	}
	SCOPE const char*
	rde_param_query_string (RDE_PARAM p, long int id)
	{
	    TRACE (("rde_param_query_string (RDE_PARAM %p, %d/%d)", p, id, p->numstr));
	    ASSERT_BOUNDS(id,p->numstr);
	    return p->string [id];
	}
	SCOPE void
	rde_param_i_ast_pop_discard (RDE_PARAM p)
	{
	    rde_stack_pop (p->mark, 1);
	}
	SCOPE void
	rde_param_i_ast_pop_rewind (RDE_PARAM p)
	{
	    long int trim = (long int) rde_stack_top (p->mark);
	    ENTER ("rde_param_i_ast_pop_rewind");
	    TRACE (("RDE_PARAM %p",p));
	    rde_stack_pop  (p->mark, 1);
	    rde_stack_trim (p->ast, (int) trim);
	    TRACE (("SV = (%p rc%d '%s')",
		    p->SV,
		    p->SV ? p->SV->refCount       : -1,
		    p->SV ? Tcl_GetString (p->SV) : ""));
	    RETURNVOID;
	}
	SCOPE void
	rde_param_i_ast_rewind (RDE_PARAM p)
	{
	    long int trim = (long int) rde_stack_top (p->mark);
	    ENTER ("rde_param_i_ast_rewind");
	    TRACE (("RDE_PARAM %p",p));
	    rde_stack_trim (p->ast, (int) trim);
	    TRACE (("SV = (%p rc%d '%s')",
		    p->SV,
		    p->SV ? p->SV->refCount       : -1,
		    p->SV ? Tcl_GetString (p->SV) : ""));
	    RETURNVOID;
	}
	SCOPE void
	rde_param_i_ast_push (RDE_PARAM p)
	{
	    rde_stack_push (p->mark, (void*) rde_stack_size (p->ast));
	}
	SCOPE void
	rde_param_i_ast_value_push (RDE_PARAM p)
	{
	    ENTER ("rde_param_i_ast_value_push");
	    TRACE (("RDE_PARAM %p",p));
	    ASSERT(p->SV,"Unable to push undefined semantic value");
	    TRACE (("rde_param_i_ast_value_push %p => (%p)/%d", p, p->SV, ));
	    TRACE (("SV = (%p rc%d '%s')", p->SV, p->SV->refCount, Tcl_GetString (p->SV)));
	    rde_stack_push (p->ast, p->SV);
	    Tcl_IncrRefCount (p->SV);
	    RETURNVOID;
	}
	static void
	ast_node_free (void* n)
	{
	    Tcl_DecrRefCount ((Tcl_Obj*) n);
	}
	SCOPE void
	rde_param_i_error_clear (RDE_PARAM p)
	{
	    ER_CLEAR (p);
	}
	SCOPE void
	rde_param_i_error_nonterminal (RDE_PARAM p, int s)
	{
	    long int pos;
	    if (!p->ER) return;
	    pos = 1 + (long int) rde_stack_top (p->LS);
	    if (p->ER->loc != pos) return;
	    error_set (p, s);
	    p->ER->loc = pos;
	}
	SCOPE void
	rde_param_i_error_pop_merge (RDE_PARAM p)
	{
	    ERROR_STATE* top = (ERROR_STATE*) rde_stack_top (p->ES);
	    
	    if (top == p->ER) {
		rde_stack_pop (p->ES, 1);
		return;
	    }
	    
	    if (!top) {
		rde_stack_pop (p->ES, 1);
		return;
	    }
	    
	    if (!p->ER) {
		rde_stack_drop (p->ES, 1);
		p->ER = top;
		
		return;
	    }
	    
	    if (top->loc < p->ER->loc) {
		rde_stack_pop (p->ES, 1);
		return;
	    }
	    
	    if (top->loc > p->ER->loc) {
		rde_stack_drop (p->ES, 1);
		error_state_free (p->ER);
		p->ER = top;
		
		return;
	    }
	    
	    rde_stack_move (p->ER->msg, top->msg);
	    rde_stack_pop  (p->ES, 1);
	}
	SCOPE void
	rde_param_i_error_push (RDE_PARAM p)
	{
	    rde_stack_push (p->ES, p->ER);
	    if (p->ER) { p->ER->refCount ++; }
	}
	static void
	error_set (RDE_PARAM p, int s)
	{
	    error_state_free (p->ER);
	    p->ER = ALLOC (ERROR_STATE);
	    p->ER->refCount = 1;
	    p->ER->loc      = p->CL;
	    p->ER->msg      = rde_stack_new (NULL);
	    ASSERT_BOUNDS(s,p->numstr);
	    rde_stack_push (p->ER->msg, (void*) s);
	}
	static void
	error_state_free (void* esx)
	{
	    ERROR_STATE* es = esx;
	    if (!es) return;
	    es->refCount --;
	    if (es->refCount > 0) return;
	    rde_stack_del (es->msg);
	    ckfree ((char*) es);
	}
	SCOPE void
	rde_param_i_loc_pop_discard (RDE_PARAM p)
	{
	    rde_stack_pop (p->LS, 1);
	}
	SCOPE void
	rde_param_i_loc_pop_rewind (RDE_PARAM p)
	{
	    p->CL = (long int) rde_stack_top (p->LS);
	    rde_stack_pop (p->LS, 1);
	}
	SCOPE void
	rde_param_i_loc_push (RDE_PARAM p)
	{
	    rde_stack_push (p->LS, (void*) p->CL);
	}
	SCOPE void
	rde_param_i_loc_rewind (RDE_PARAM p)
	{
	    p->CL = (long int) rde_stack_top (p->LS);
	}
	SCOPE void
	rde_param_i_input_next (RDE_PARAM p, int m)
	{
	    int leni;
	    char* ch;
	    ASSERT_BOUNDS(m,p->numstr);
	    p->CL ++;
	    if (p->CL < rde_tc_size (p->TC)) {
		
		rde_tc_get (p->TC, p->CL, &p->CC, &p->CC_len);
		ASSERT_BOUNDS (p->CC_len, TCL_UTF_MAX);
		p->ST = 1;
		ER_CLEAR (p);
		return;
	    }
	    if (!p->IN || 
		Tcl_Eof (p->IN) ||
		(Tcl_ReadChars (p->IN, p->readbuf, 1, 0) <= 0)) {
		
		p->ST = 0;
		error_set (p, m);
		return;
	    }
	    
	    ch = Tcl_GetStringFromObj (p->readbuf, &leni);
	    ASSERT_BOUNDS (leni, TCL_UTF_MAX);
	    p->CC = rde_tc_append (p->TC, ch, leni);
	    p->CC_len = leni;
	    p->ST = 1;
	    ER_CLEAR (p);
	}
	SCOPE void
	rde_param_i_status_fail (RDE_PARAM p)
	{
	    p->ST = 0;
	}
	SCOPE void
	rde_param_i_status_ok (RDE_PARAM p)
	{
	    p->ST = 1;
	}
	SCOPE void
	rde_param_i_status_negate (RDE_PARAM p)
	{
	    p->ST = !p->ST;
	}
	SCOPE int 
	rde_param_i_symbol_restore (RDE_PARAM p, int s)
	{
	    NC_STATE*      scs;
	    Tcl_HashEntry* hPtr;
	    Tcl_HashTable* tablePtr;
	    
	    hPtr = Tcl_FindHashEntry (&p->NC, (char*) p->CL);
	    if (!hPtr) { return 0; }
	    tablePtr = (Tcl_HashTable*) Tcl_GetHashValue (hPtr);
	    hPtr = Tcl_FindHashEntry (tablePtr, (char*) s);
	    if (!hPtr) { return 0; }
	    
	    scs = Tcl_GetHashValue (hPtr);
	    p->CL = scs->CL;
	    p->ST = scs->ST;
	    error_state_free (p->ER);
	    p->ER = scs->ER;
	    if (p->ER) { p->ER->refCount ++; }
	    TRACE (("SV_RESTORE (%p) '%s'",scs->SV, scs->SV ? Tcl_GetString (scs->SV):""));
	    SV_SET (p, scs->SV);
	    return 1;
	}
	SCOPE void
	rde_param_i_symbol_save (RDE_PARAM p, int s)
	{
	    long int       at = (long int) rde_stack_top (p->LS);
	    NC_STATE*      scs;
	    Tcl_HashEntry* hPtr;
	    Tcl_HashTable* tablePtr;
	    int            isnew;
	    ENTER ("rde_param_i_symbol_save");
	    TRACE (("RDE_PARAM %p",p));
	    TRACE (("INT       %d",s));
	    
	    hPtr = Tcl_CreateHashEntry (&p->NC, (char*) at, &isnew);
	    if (isnew) {
		tablePtr = ALLOC (Tcl_HashTable);
		Tcl_InitHashTable (tablePtr, TCL_ONE_WORD_KEYS);
		Tcl_SetHashValue (hPtr, tablePtr);
	    } else {
		tablePtr = (Tcl_HashTable*) Tcl_GetHashValue (hPtr);
	    }
	    hPtr = Tcl_CreateHashEntry (tablePtr, (char*) s, &isnew);
	    if (isnew) {
		
		scs = ALLOC (NC_STATE);
		scs->CL = p->CL;
		scs->ST = p->ST;
		TRACE (("SV_CACHE (%p '%s')", p->SV, p->SV ? Tcl_GetString(p->SV) : ""));
		scs->SV = p->SV;
		if (scs->SV) { Tcl_IncrRefCount (scs->SV); }
		scs->ER = p->ER;
		if (scs->ER) { scs->ER->refCount ++; }
		Tcl_SetHashValue (hPtr, scs);
	    } else {
		
		scs = (NC_STATE*) Tcl_GetHashValue (hPtr);
		scs->CL = p->CL;
		scs->ST = p->ST;
		TRACE (("SV_CACHE/over (%p '%s')", p->SV, p->SV ? Tcl_GetString(p->SV) : "" ));
		if (scs->SV) { Tcl_DecrRefCount (scs->SV); }
		scs->SV = p->SV;
		if (scs->SV) { Tcl_IncrRefCount (scs->SV); }
		error_state_free (scs->ER);
		scs->ER = p->ER;
		if (scs->ER) { scs->ER->refCount ++; }
	    }
	    TRACE (("SV = (%p rc%d '%s')",
		    p->SV,
		    p->SV ? p->SV->refCount       : -1,
		    p->SV ? Tcl_GetString (p->SV) : ""));
	    RETURNVOID;
	}
	SCOPE void
	rde_param_i_test_alnum (RDE_PARAM p)
	{
	    test_class (p, Tcl_UniCharIsAlnum, tc_alnum);
	}
	SCOPE void
	rde_param_i_test_alpha (RDE_PARAM p)
	{
	    test_class (p, Tcl_UniCharIsAlpha, tc_alpha);
	}
	SCOPE void
	rde_param_i_test_ascii (RDE_PARAM p)
	{
	    test_class (p, UniCharIsAscii, tc_ascii);
	}
	SCOPE void
	rde_param_i_test_char (RDE_PARAM p, char* c, int msg)
	{
	    ASSERT_BOUNDS(msg,p->numstr);
	    p->ST = Tcl_UtfNcmp (p->CC, c, 1) == 0;
	    if (p->ST) {
		ER_CLEAR (p);
	    } else {
		error_set (p, msg);
		p->CL --;
	    }
	}
	SCOPE void
	rde_param_i_test_ddigit (RDE_PARAM p)
	{
	    test_class (p, UniCharIsDecDigit, tc_ddigit);
	}
	SCOPE void
	rde_param_i_test_digit (RDE_PARAM p)
	{
	    test_class (p, Tcl_UniCharIsDigit, tc_digit);
	}
	SCOPE void
	rde_param_i_test_graph (RDE_PARAM p)
	{
	    test_class (p, Tcl_UniCharIsGraph, tc_graph);
	}
	SCOPE void
	rde_param_i_test_lower (RDE_PARAM p)
	{
	    test_class (p, Tcl_UniCharIsLower, tc_lower);
	}
	SCOPE void
	rde_param_i_test_print (RDE_PARAM p)
	{
	    test_class (p, Tcl_UniCharIsPrint, tc_printable);
	}
	SCOPE void
	rde_param_i_test_punct (RDE_PARAM p)
	{
	    test_class (p, Tcl_UniCharIsPunct, tc_punct);
	}
	SCOPE void
	rde_param_i_test_range (RDE_PARAM p, char* s, char* e, int msg)
	{
	    ASSERT_BOUNDS(msg,p->numstr);
	    p->ST =
		(Tcl_UtfNcmp (s, p->CC, 1) <= 0) &&
		(Tcl_UtfNcmp (p->CC, e, 1) <= 0);
	    if (p->ST) {
		ER_CLEAR (p);
	    } else {
		error_set (p, msg);
		p->CL --;
	    }
	}
	SCOPE void
	rde_param_i_test_space (RDE_PARAM p)
	{
	    test_class (p, Tcl_UniCharIsSpace, tc_space);
	}
	SCOPE void
	rde_param_i_test_upper (RDE_PARAM p)
	{
	    test_class (p, Tcl_UniCharIsUpper, tc_upper);
	}
	SCOPE void
	rde_param_i_test_wordchar (RDE_PARAM p)
	{
	    test_class (p, Tcl_UniCharIsWordChar, tc_wordchar);
	}
	SCOPE void
	rde_param_i_test_xdigit (RDE_PARAM p)
	{
	    test_class (p, UniCharIsHexDigit, tc_xdigit);
	}
	static void
	test_class (RDE_PARAM p, UniCharClass class, test_class_id id)
	{
	    Tcl_UniChar ch;
	    Tcl_UtfToUniChar(p->CC, &ch);
	    ASSERT_BOUNDS(id,p->numstr);
	    p->ST = !!class (ch);
	    
	    if (p->ST) {
		ER_CLEAR (p);
	    } else {
		error_set (p, id);
		p->CL --;
	    }
	}
	static int
	UniCharIsAscii (int character)
	{
	    return (character >= 0) && (character < 0x80);
	}
	static int
	UniCharIsHexDigit (int character)
	{
	    return (character >= 0) && (character < 0x80) && isxdigit(character);
	}
	static int
	UniCharIsDecDigit (int character)
	{
	    return (character >= 0) && (character < 0x80) && isdigit(character);
	}
	SCOPE void
	rde_param_i_value_clear (RDE_PARAM p)
	{
	    SV_CLEAR (p);
	}
	SCOPE void
	rde_param_i_value_leaf (RDE_PARAM p, int s)
	{
	    Tcl_Obj* newsv;
	    Tcl_Obj* ov [3];
	    long int pos = 1 + (long int) rde_stack_top (p->LS);
	    ASSERT_BOUNDS(s,p->numstr);
	    ov [0] = Tcl_NewStringObj (p->string[s], -1);
	    ov [1] = Tcl_NewIntObj (pos);
	    ov [2] = Tcl_NewIntObj (p->CL);
	    newsv = Tcl_NewListObj (3, ov);
	    TRACE (("rde_param_i_value_leaf => '%s'",Tcl_GetString (newsv)));
	    SV_SET (p, newsv);
	}
	SCOPE void
	rde_param_i_value_reduce (RDE_PARAM p, int s)
	{
	    Tcl_Obj*  newsv;
	    int       oc, i, j;
	    Tcl_Obj** ov;
	    long int  ac;
	    Tcl_Obj** av;
	    long int pos   = 1 + (long int) rde_stack_top (p->LS);
	    long int mark  = (long int) rde_stack_top (p->mark);
	    long int asize = rde_stack_size (p->ast);
	    long int new   = asize - mark;
	    ASSERT (new >= 0, "Bad number of elements to reduce");
	    ov = NALLOC (3+new, Tcl_Obj*);
	    ASSERT_BOUNDS(s,p->numstr);
	    ov [0] = Tcl_NewStringObj (p->string[s], -1);
	    ov [1] = Tcl_NewIntObj (pos);
	    ov [2] = Tcl_NewIntObj (p->CL);
	    rde_stack_get (p->ast, &ac, (void***) &av);
	    for (i = 3, j = mark; j < asize; i++, j++) {
		ASSERT_BOUNDS (i, 3+new);
		ASSERT_BOUNDS (j, ac);
		ov [i] = av [j];
	    }
	    ASSERT (i == 3+new, "Reduction result incomplete");
	    newsv = Tcl_NewListObj (3+new, ov);
	    TRACE (("rde_param_i_value_reduce => '%s'",Tcl_GetString (newsv)));
	    SV_SET (p, newsv);
	    ckfree ((char*) ov);
	}
	static int
	er_int_compare (const void* a, const void* b)
	{
	    long int ai = *((long int*) a);
	    long int bi = *((long int*) b);
	    if (ai < bi) { return -1; }
	    if (ai > bi) { return  1; }
	    return 0;
	}
	SCOPE int
	rde_param_i_symbol_start (RDE_PARAM p, int s)
	{
	    if (rde_param_i_symbol_restore (p, s)) {
		if (p->ST) {
		    rde_stack_push (p->ast, p->SV);
		    Tcl_IncrRefCount (p->SV);
		}
		return 1;
	    }
	    rde_stack_push (p->LS, (void*) p->CL);
	    return 0;
	}
	SCOPE int
	rde_param_i_symbol_start_d (RDE_PARAM p, int s)
	{
	    if (rde_param_i_symbol_restore (p, s)) {
		if (p->ST) {
		    rde_stack_push (p->ast, p->SV);
		    Tcl_IncrRefCount (p->SV);
		}
		return 1;
	    }
	    rde_stack_push (p->LS,   (void*) p->CL);
	    rde_stack_push (p->mark, (void*) rde_stack_size (p->ast));
	    return 0;
	}
	SCOPE int
	rde_param_i_symbol_void_start (RDE_PARAM p, int s)
	{
	    if (rde_param_i_symbol_restore (p, s)) return 1;
	    rde_stack_push (p->LS, (void*) p->CL);
	    return 0;
	}
	SCOPE int
	rde_param_i_symbol_void_start_d (RDE_PARAM p, int s)
	{
	    if (rde_param_i_symbol_restore (p, s)) return 1;
	    rde_stack_push (p->LS,   (void*) p->CL);
	    rde_stack_push (p->mark, (void*) rde_stack_size (p->ast));
	    return 0;
	}
	SCOPE void
	rde_param_i_symbol_done_d_reduce (RDE_PARAM p, int s, int m)
	{
	    if (p->ST) {
		rde_param_i_value_reduce (p, s);
	    } else {
		SV_CLEAR (p);
	    }
	    rde_param_i_symbol_save       (p, s);
	    rde_param_i_error_nonterminal (p, m);
	    rde_param_i_ast_pop_rewind    (p);
	    rde_stack_pop (p->LS, 1);
	    if (p->ST) {
		rde_stack_push (p->ast, p->SV);
		Tcl_IncrRefCount (p->SV);
	    }
	}
	SCOPE void
	rde_param_i_symbol_done_leaf (RDE_PARAM p, int s, int m)
	{
	    if (p->ST) {
		rde_param_i_value_leaf (p, s);
	    } else {
		SV_CLEAR (p);
	    }
	    rde_param_i_symbol_save       (p, s);
	    rde_param_i_error_nonterminal (p, m);
	    rde_stack_pop (p->LS, 1);
	    if (p->ST) {
		rde_stack_push (p->ast, p->SV);
		Tcl_IncrRefCount (p->SV);
	    }
	}
	SCOPE void
	rde_param_i_symbol_done_d_leaf (RDE_PARAM p, int s, int m)
	{
	    if (p->ST) {
		rde_param_i_value_leaf (p, s);
	    } else {
		SV_CLEAR (p);
	    }
	    rde_param_i_symbol_save       (p, s);
	    rde_param_i_error_nonterminal (p, m);
	    rde_param_i_ast_pop_rewind    (p);
	    rde_stack_pop (p->LS, 1);
	    if (p->ST) {
		rde_stack_push (p->ast, p->SV);
		Tcl_IncrRefCount (p->SV);
	    }
	}
	SCOPE void
	rde_param_i_symbol_done_void (RDE_PARAM p, int s, int m)
	{
	    SV_CLEAR (p);
	    rde_param_i_symbol_save       (p, s);
	    rde_param_i_error_nonterminal (p, m);
	    rde_stack_pop (p->LS, 1);
	}
	SCOPE void
	rde_param_i_symbol_done_d_void (RDE_PARAM p, int s, int m)
	{
	    SV_CLEAR (p);
	    rde_param_i_symbol_save       (p, s);
	    rde_param_i_error_nonterminal (p, m);
	    rde_param_i_ast_pop_rewind    (p);
	    rde_stack_pop (p->LS, 1);
	}
	SCOPE void
	rde_param_i_next_char (RDE_PARAM p, char* c, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_char (p, c, m);
	}
	SCOPE void
	rde_param_i_next_range (RDE_PARAM p, char* s, char* e, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_range (p, s, e, m);
	}
	SCOPE void
	rde_param_i_next_alnum (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_alnum (p);
	}
	SCOPE void
	rde_param_i_next_alpha (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_alpha (p);
	}
	SCOPE void
	rde_param_i_next_ascii (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_ascii (p);
	}
	SCOPE void
	rde_param_i_next_ddigit (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_ddigit (p);
	}
	SCOPE void
	rde_param_i_next_digit (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_digit (p);
	}
	SCOPE void
	rde_param_i_next_graph (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_graph (p);
	}
	SCOPE void
	rde_param_i_next_lower (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_lower (p);
	}
	SCOPE void
	rde_param_i_next_print (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_print (p);
	}
	SCOPE void
	rde_param_i_next_punct (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_punct (p);
	}
	SCOPE void
	rde_param_i_next_space (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_space (p);
	}
	SCOPE void
	rde_param_i_next_upper (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_upper (p);
	}
	SCOPE void
	rde_param_i_next_wordchar (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_wordchar (p);
	}
	SCOPE void
	rde_param_i_next_xdigit (RDE_PARAM p, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    rde_param_i_test_xdigit (p);
	}
	SCOPE void
	rde_param_i_notahead_start_d (RDE_PARAM p)
	{
	    rde_stack_push (p->LS, (void*) p->CL);
	    rde_stack_push (p->mark, (void*) rde_stack_size (p->ast));
	}
	SCOPE void
	rde_param_i_notahead_exit_d (RDE_PARAM p)
	{
	    if (p->ST) {
		rde_param_i_ast_pop_rewind (p); 
	    } else {
		rde_stack_pop (p->mark, 1);
	    }
	    p->CL = (long int) rde_stack_top (p->LS);
	    rde_stack_pop (p->LS, 1);
	    p->ST = !p->ST;
	}
	SCOPE void
	rde_param_i_notahead_exit (RDE_PARAM p)
	{
	    p->CL = (long int) rde_stack_top (p->LS);
	    rde_stack_pop (p->LS, 1);
	    p->ST = !p->ST;
	}
	SCOPE void
	rde_param_i_state_push_2 (RDE_PARAM p)
	{
	    
	    rde_stack_push (p->LS, (void*) p->CL);
	    rde_stack_push (p->ES, p->ER);
	    if (p->ER) { p->ER->refCount ++; }
	}
	SCOPE void
	rde_param_i_state_push_void (RDE_PARAM p)
	{
	    rde_stack_push (p->LS, (void*) p->CL);
	    ER_CLEAR (p);
	    rde_stack_push (p->ES, p->ER);
	    
	}
	SCOPE void
	rde_param_i_state_push_value (RDE_PARAM p)
	{
	    rde_stack_push (p->mark, (void*) rde_stack_size (p->ast));
	    rde_stack_push (p->LS, (void*) p->CL);
	    ER_CLEAR (p);
	    rde_stack_push (p->ES, p->ER);
	    
	}
	SCOPE void
	rde_param_i_state_merge_ok (RDE_PARAM p)
	{
	    rde_param_i_error_pop_merge (p);
	    if (!p->ST) {
		p->ST = 1;
		p->CL = (long int) rde_stack_top (p->LS);
	    }
	    rde_stack_pop (p->LS, 1);
	}
	SCOPE void
	rde_param_i_state_merge_void (RDE_PARAM p)
	{
	    rde_param_i_error_pop_merge (p);
	    if (!p->ST) {
		p->CL = (long int) rde_stack_top (p->LS);
	    }
	    rde_stack_pop (p->LS, 1);
	}
	SCOPE void
	rde_param_i_state_merge_value (RDE_PARAM p)
	{
	    rde_param_i_error_pop_merge (p);
	    if (!p->ST) {
		long int trim = (long int) rde_stack_top (p->mark);
		rde_stack_trim (p->ast, (int) trim);
		p->CL = (long int) rde_stack_top (p->LS);
	    }
	    rde_stack_pop (p->mark, 1);
	    rde_stack_pop (p->LS, 1);
	}
	SCOPE int
	rde_param_i_kleene_close (RDE_PARAM p)
	{
	    int stop = !p->ST;
	    rde_param_i_error_pop_merge (p);
	    if (stop) {
		p->ST = 1;
		p->CL = (long int) rde_stack_top (p->LS);
	    }
	    rde_stack_pop (p->LS, 1);
	    return stop;
	}
	SCOPE int
	rde_param_i_kleene_abort (RDE_PARAM p)
	{
	    int stop = !p->ST;
	    if (stop) {
		p->CL = (long int) rde_stack_top (p->LS);
	    }
	    rde_stack_pop (p->LS, 1);
	    return stop;
	}
	SCOPE int
	rde_param_i_seq_void2void (RDE_PARAM p)
	{
	    rde_param_i_error_pop_merge (p);
	    if (p->ST) {
		rde_stack_push (p->ES, p->ER);
		if (p->ER) { p->ER->refCount ++; }
		return 0;
	    } else {
		p->CL = (long int) rde_stack_top (p->LS);
		rde_stack_pop (p->LS, 1);
		return 1;
	    }
	}
	SCOPE int
	rde_param_i_seq_void2value (RDE_PARAM p)
	{
	    rde_param_i_error_pop_merge (p);
	    if (p->ST) {
		rde_stack_push (p->mark, (void*) rde_stack_size (p->ast));
		rde_stack_push (p->ES, p->ER);
		if (p->ER) { p->ER->refCount ++; }
		return 0;
	    } else {
		p->CL = (long int) rde_stack_top (p->LS);
		rde_stack_pop (p->LS, 1);
		return 1;
	    }
	}
	SCOPE int
	rde_param_i_seq_value2value (RDE_PARAM p)
	{
	    rde_param_i_error_pop_merge (p);
	    if (p->ST) {
		rde_stack_push (p->ES, p->ER);
		if (p->ER) { p->ER->refCount ++; }
		return 0;
	    } else {
		long int trim = (long int) rde_stack_top (p->mark);
		rde_stack_pop  (p->mark, 1);
		rde_stack_trim (p->ast, (int) trim);
		p->CL = (long int) rde_stack_top (p->LS);
		rde_stack_pop (p->LS, 1);
		return 1;
	    }
	}
	SCOPE int
	rde_param_i_bra_void2void (RDE_PARAM p)
	{
	    rde_param_i_error_pop_merge (p);
	    if (p->ST) {
		rde_stack_pop (p->LS, 1);
	    } else {
		p->CL = (long int) rde_stack_top (p->LS);
		rde_stack_push (p->ES, p->ER);
		if (p->ER) { p->ER->refCount ++; }
	    }
	    return p->ST;
	}
	SCOPE int
	rde_param_i_bra_void2value (RDE_PARAM p)
	{
	    rde_param_i_error_pop_merge (p);
	    if (p->ST) {
		rde_stack_pop (p->LS, 1);
	    } else {
		rde_stack_push (p->mark, (void*) rde_stack_size (p->ast));
		p->CL = (long int) rde_stack_top (p->LS);
		rde_stack_push (p->ES, p->ER);
		if (p->ER) { p->ER->refCount ++; }
	    }
	    return p->ST;
	}
	SCOPE int
	rde_param_i_bra_value2void (RDE_PARAM p)
	{
	    rde_param_i_error_pop_merge (p);
	    if (p->ST) {
		rde_stack_pop (p->mark, 1);
		rde_stack_pop (p->LS, 1);
	    } else {
		long int trim = (long int) rde_stack_top (p->mark);
		rde_stack_pop  (p->mark, 1);
		rde_stack_trim (p->ast, (int) trim);
		p->CL = (long int) rde_stack_top (p->LS);
		rde_stack_push (p->ES, p->ER);
		if (p->ER) { p->ER->refCount ++; }
	    }
	    return p->ST;
	}
	SCOPE int
	rde_param_i_bra_value2value (RDE_PARAM p)
	{
	    rde_param_i_error_pop_merge (p);
	    if (p->ST) {
		rde_stack_pop (p->mark, 1);
		rde_stack_pop (p->LS, 1);
	    } else {
		long int trim = (long int) rde_stack_top (p->mark);
		rde_stack_trim (p->ast, (int) trim);
		p->CL = (long int) rde_stack_top (p->LS);
		rde_stack_push (p->ES, p->ER);
		if (p->ER) { p->ER->refCount ++; }
	    }
	    return p->ST;
	}
	SCOPE void
	rde_param_i_next_str (RDE_PARAM p, char* str, int m)
	{
	    int at = p->CL;
	    while (*str) {
		rde_param_i_input_next (p, m);
		if (!p->ST) {
		    p->CL = at;
		    return;
		}
		rde_param_i_test_char (p, str, m);
		if (!p->ST) {
		    p->CL = at;
		    return;
		}
		str = Tcl_UtfNext (str);
	    }
	}
	SCOPE void
	rde_param_i_next_class (RDE_PARAM p, char* class, int m)
	{
	    rde_param_i_input_next (p, m);
	    if (!p->ST) return;
	    while (*class) {
		p->ST = Tcl_UtfNcmp (p->CC, class, 1) == 0;
		if (p->ST) {
		    ER_CLEAR (p);
		    return;
		}
		class = Tcl_UtfNext (class);
	    }
	    error_set (p, m);
	    p->CL --;
	}
	

    }

    # # ## ### ###### ######## #############
    ## BEGIN of GENERATED CODE. DO NOT EDIT.

    critcl::ccode {
	/* -*- c -*- */

        /*
         * Declaring the parse functions
         */
        
        static void sequence_4 (RDE_PARAM p);
        static void sym_ALNUM (RDE_PARAM p);
        static void sequence_9 (RDE_PARAM p);
        static void sym_ALPHA (RDE_PARAM p);
        static void sequence_14 (RDE_PARAM p);
        static void sym_AND (RDE_PARAM p);
        static void sym_APOSTROPH (RDE_PARAM p);
        static void sequence_21 (RDE_PARAM p);
        static void sym_ASCII (RDE_PARAM p);
        static void choice_26 (RDE_PARAM p);
        static void sequence_29 (RDE_PARAM p);
        static void sym_Attribute (RDE_PARAM p);
        static void choice_37 (RDE_PARAM p);
        static void sym_Char (RDE_PARAM p);
        static void sequence_44 (RDE_PARAM p);
        static void sym_CharOctalFull (RDE_PARAM p);
        static void optional_50 (RDE_PARAM p);
        static void sequence_52 (RDE_PARAM p);
        static void sym_CharOctalPart (RDE_PARAM p);
        static void sequence_57 (RDE_PARAM p);
        static void sym_CharSpecial (RDE_PARAM p);
        static void notahead_61 (RDE_PARAM p);
        static void sequence_64 (RDE_PARAM p);
        static void sym_CharUnescaped (RDE_PARAM p);
        static void optional_72 (RDE_PARAM p);
        static void sequence_74 (RDE_PARAM p);
        static void optional_76 (RDE_PARAM p);
        static void sequence_78 (RDE_PARAM p);
        static void optional_80 (RDE_PARAM p);
        static void sequence_82 (RDE_PARAM p);
        static void sym_CharUnicode (RDE_PARAM p);
        static void notahead_87 (RDE_PARAM p);
        static void sequence_90 (RDE_PARAM p);
        static void kleene_92 (RDE_PARAM p);
        static void sequence_96 (RDE_PARAM p);
        static void sym_Class (RDE_PARAM p);
        static void sequence_101 (RDE_PARAM p);
        static void sym_CLOSE (RDE_PARAM p);
        static void sym_CLOSEB (RDE_PARAM p);
        static void sequence_108 (RDE_PARAM p);
        static void sym_COLON (RDE_PARAM p);
        static void notahead_113 (RDE_PARAM p);
        static void sequence_116 (RDE_PARAM p);
        static void kleene_118 (RDE_PARAM p);
        static void sequence_121 (RDE_PARAM p);
        static void sym_COMMENT (RDE_PARAM p);
        static void sequence_126 (RDE_PARAM p);
        static void sym_CONTROL (RDE_PARAM p);
        static void sym_DAPOSTROPH (RDE_PARAM p);
        static void sequence_133 (RDE_PARAM p);
        static void sym_DDIGIT (RDE_PARAM p);
        static void optional_137 (RDE_PARAM p);
        static void sequence_143 (RDE_PARAM p);
        static void sym_Definition (RDE_PARAM p);
        static void sequence_148 (RDE_PARAM p);
        static void sym_DIGIT (RDE_PARAM p);
        static void sequence_153 (RDE_PARAM p);
        static void sym_DOT (RDE_PARAM p);
        static void sequence_158 (RDE_PARAM p);
        static void sym_END (RDE_PARAM p);
        static void notahead_162 (RDE_PARAM p);
        static void sym_EOF (RDE_PARAM p);
        static void sym_EOL (RDE_PARAM p);
        static void sequence_170 (RDE_PARAM p);
        static void kleene_172 (RDE_PARAM p);
        static void sequence_174 (RDE_PARAM p);
        static void sym_Expression (RDE_PARAM p);
        static void sequence_180 (RDE_PARAM p);
        static void sym_Final (RDE_PARAM p);
        static void kleene_186 (RDE_PARAM p);
        static void sequence_190 (RDE_PARAM p);
        static void sym_Grammar (RDE_PARAM p);
        static void sequence_195 (RDE_PARAM p);
        static void sym_GRAPH (RDE_PARAM p);
        static void sequence_201 (RDE_PARAM p);
        static void sym_Header (RDE_PARAM p);
        static void choice_206 (RDE_PARAM p);
        static void choice_210 (RDE_PARAM p);
        static void kleene_212 (RDE_PARAM p);
        static void sequence_214 (RDE_PARAM p);
        static void sym_Ident (RDE_PARAM p);
        static void sequence_219 (RDE_PARAM p);
        static void sym_Identifier (RDE_PARAM p);
        static void sequence_224 (RDE_PARAM p);
        static void sym_IS (RDE_PARAM p);
        static void sequence_229 (RDE_PARAM p);
        static void sym_LEAF (RDE_PARAM p);
        static void notahead_234 (RDE_PARAM p);
        static void sequence_237 (RDE_PARAM p);
        static void kleene_239 (RDE_PARAM p);
        static void sequence_243 (RDE_PARAM p);
        static void notahead_247 (RDE_PARAM p);
        static void sequence_250 (RDE_PARAM p);
        static void kleene_252 (RDE_PARAM p);
        static void sequence_256 (RDE_PARAM p);
        static void choice_258 (RDE_PARAM p);
        static void sym_Literal (RDE_PARAM p);
        static void sequence_263 (RDE_PARAM p);
        static void sym_LOWER (RDE_PARAM p);
        static void sequence_268 (RDE_PARAM p);
        static void sym_NOT (RDE_PARAM p);
        static void sequence_273 (RDE_PARAM p);
        static void sym_OPEN (RDE_PARAM p);
        static void sym_OPENB (RDE_PARAM p);
        static void sequence_280 (RDE_PARAM p);
        static void sym_PEG (RDE_PARAM p);
        static void sequence_285 (RDE_PARAM p);
        static void sym_PLUS (RDE_PARAM p);
        static void choice_290 (RDE_PARAM p);
        static void optional_292 (RDE_PARAM p);
        static void sequence_295 (RDE_PARAM p);
        static void sym_Prefix (RDE_PARAM p);
        static void sequence_316 (RDE_PARAM p);
        static void choice_321 (RDE_PARAM p);
        static void sym_Primary (RDE_PARAM p);
        static void sequence_326 (RDE_PARAM p);
        static void sym_PRINTABLE (RDE_PARAM p);
        static void sequence_331 (RDE_PARAM p);
        static void sym_PUNCT (RDE_PARAM p);
        static void sequence_336 (RDE_PARAM p);
        static void sym_QUESTION (RDE_PARAM p);
        static void sequence_342 (RDE_PARAM p);
        static void choice_345 (RDE_PARAM p);
        static void sym_Range (RDE_PARAM p);
        static void sequence_350 (RDE_PARAM p);
        static void sym_SEMICOLON (RDE_PARAM p);
        static void poskleene_354 (RDE_PARAM p);
        static void sym_Sequence (RDE_PARAM p);
        static void sequence_359 (RDE_PARAM p);
        static void sym_SLASH (RDE_PARAM p);
        static void sequence_364 (RDE_PARAM p);
        static void sym_SPACE (RDE_PARAM p);
        static void sequence_369 (RDE_PARAM p);
        static void sym_STAR (RDE_PARAM p);
        static void sym_StartExpr (RDE_PARAM p);
        static void choice_381 (RDE_PARAM p);
        static void optional_383 (RDE_PARAM p);
        static void sequence_385 (RDE_PARAM p);
        static void sym_Suffix (RDE_PARAM p);
        static void sym_TO (RDE_PARAM p);
        static void sequence_392 (RDE_PARAM p);
        static void sym_UPPER (RDE_PARAM p);
        static void sequence_397 (RDE_PARAM p);
        static void sym_VOID (RDE_PARAM p);
        static void choice_402 (RDE_PARAM p);
        static void kleene_404 (RDE_PARAM p);
        static void sym_WHITESPACE (RDE_PARAM p);
        static void sequence_409 (RDE_PARAM p);
        static void sym_WORDCHAR (RDE_PARAM p);
        static void sequence_414 (RDE_PARAM p);
        static void sym_XDIGIT (RDE_PARAM p);
        
        /*
         * Precomputed table of strings (symbols, error messages, etc.).
         */
        
        static char const* p_string [170] = {
            /*        0 = */   "str '<alnum>'",
            /*        1 = */   "n ALNUM",
            /*        2 = */   "ALNUM",
            /*        3 = */   "str '<alpha>'",
            /*        4 = */   "n ALPHA",
            /*        5 = */   "ALPHA",
            /*        6 = */   "t &",
            /*        7 = */   "n AND",
            /*        8 = */   "AND",
            /*        9 = */   "t '",
            /*       10 = */   "n APOSTROPH",
            /*       11 = */   "APOSTROPH",
            /*       12 = */   "str '<ascii>'",
            /*       13 = */   "n ASCII",
            /*       14 = */   "ASCII",
            /*       15 = */   "n Attribute",
            /*       16 = */   "Attribute",
            /*       17 = */   "n Char",
            /*       18 = */   "Char",
            /*       19 = */   "t \134",
            /*       20 = */   ".. 0 2",
            /*       21 = */   ".. 0 7",
            /*       22 = */   "n CharOctalFull",
            /*       23 = */   "CharOctalFull",
            /*       24 = */   "n CharOctalPart",
            /*       25 = */   "CharOctalPart",
            /*       26 = */   "cl 'nrt'\42\133\135\134'",
            /*       27 = */   "n CharSpecial",
            /*       28 = */   "CharSpecial",
            /*       29 = */   "dot",
            /*       30 = */   "n CharUnescaped",
            /*       31 = */   "CharUnescaped",
            /*       32 = */   "str '\134u'",
            /*       33 = */   "xdigit",
            /*       34 = */   "n CharUnicode",
            /*       35 = */   "CharUnicode",
            /*       36 = */   "n Class",
            /*       37 = */   "Class",
            /*       38 = */   "t \51",
            /*       39 = */   "n CLOSE",
            /*       40 = */   "CLOSE",
            /*       41 = */   "t \135",
            /*       42 = */   "n CLOSEB",
            /*       43 = */   "CLOSEB",
            /*       44 = */   "t :",
            /*       45 = */   "n COLON",
            /*       46 = */   "COLON",
            /*       47 = */   "t #",
            /*       48 = */   "n COMMENT",
            /*       49 = */   "COMMENT",
            /*       50 = */   "str '<control>'",
            /*       51 = */   "n CONTROL",
            /*       52 = */   "CONTROL",
            /*       53 = */   "t \42",
            /*       54 = */   "n DAPOSTROPH",
            /*       55 = */   "DAPOSTROPH",
            /*       56 = */   "str '<ddigit>'",
            /*       57 = */   "n DDIGIT",
            /*       58 = */   "DDIGIT",
            /*       59 = */   "n Definition",
            /*       60 = */   "Definition",
            /*       61 = */   "str '<digit>'",
            /*       62 = */   "n DIGIT",
            /*       63 = */   "DIGIT",
            /*       64 = */   "t .",
            /*       65 = */   "n DOT",
            /*       66 = */   "DOT",
            /*       67 = */   "str 'END'",
            /*       68 = */   "n END",
            /*       69 = */   "END",
            /*       70 = */   "n EOF",
            /*       71 = */   "EOF",
            /*       72 = */   "cl '\n\r'",
            /*       73 = */   "n EOL",
            /*       74 = */   "EOL",
            /*       75 = */   "n Expression",
            /*       76 = */   "Expression",
            /*       77 = */   "n Final",
            /*       78 = */   "Final",
            /*       79 = */   "n Grammar",
            /*       80 = */   "Grammar",
            /*       81 = */   "str '<graph>'",
            /*       82 = */   "n GRAPH",
            /*       83 = */   "GRAPH",
            /*       84 = */   "n Header",
            /*       85 = */   "Header",
            /*       86 = */   "cl '_:'",
            /*       87 = */   "alpha",
            /*       88 = */   "alnum",
            /*       89 = */   "n Ident",
            /*       90 = */   "Ident",
            /*       91 = */   "n Identifier",
            /*       92 = */   "Identifier",
            /*       93 = */   "str '<-'",
            /*       94 = */   "n IS",
            /*       95 = */   "IS",
            /*       96 = */   "str 'leaf'",
            /*       97 = */   "n LEAF",
            /*       98 = */   "LEAF",
            /*       99 = */   "n Literal",
            /*      100 = */   "Literal",
            /*      101 = */   "str '<lower>'",
            /*      102 = */   "n LOWER",
            /*      103 = */   "LOWER",
            /*      104 = */   "t !",
            /*      105 = */   "n NOT",
            /*      106 = */   "NOT",
            /*      107 = */   "t \50",
            /*      108 = */   "n OPEN",
            /*      109 = */   "OPEN",
            /*      110 = */   "t \133",
            /*      111 = */   "n OPENB",
            /*      112 = */   "OPENB",
            /*      113 = */   "str 'PEG'",
            /*      114 = */   "n PEG",
            /*      115 = */   "PEG",
            /*      116 = */   "t +",
            /*      117 = */   "n PLUS",
            /*      118 = */   "PLUS",
            /*      119 = */   "n Prefix",
            /*      120 = */   "Prefix",
            /*      121 = */   "n Primary",
            /*      122 = */   "Primary",
            /*      123 = */   "str '<print>'",
            /*      124 = */   "n PRINTABLE",
            /*      125 = */   "PRINTABLE",
            /*      126 = */   "str '<punct>'",
            /*      127 = */   "n PUNCT",
            /*      128 = */   "PUNCT",
            /*      129 = */   "t ?",
            /*      130 = */   "n QUESTION",
            /*      131 = */   "QUESTION",
            /*      132 = */   "n Range",
            /*      133 = */   "Range",
            /*      134 = */   "t \73",
            /*      135 = */   "n SEMICOLON",
            /*      136 = */   "SEMICOLON",
            /*      137 = */   "n Sequence",
            /*      138 = */   "Sequence",
            /*      139 = */   "t /",
            /*      140 = */   "n SLASH",
            /*      141 = */   "SLASH",
            /*      142 = */   "str '<space>'",
            /*      143 = */   "n SPACE",
            /*      144 = */   "SPACE",
            /*      145 = */   "t *",
            /*      146 = */   "n STAR",
            /*      147 = */   "STAR",
            /*      148 = */   "n StartExpr",
            /*      149 = */   "StartExpr",
            /*      150 = */   "n Suffix",
            /*      151 = */   "Suffix",
            /*      152 = */   "t -",
            /*      153 = */   "n TO",
            /*      154 = */   "TO",
            /*      155 = */   "str '<upper>'",
            /*      156 = */   "n UPPER",
            /*      157 = */   "UPPER",
            /*      158 = */   "str 'void'",
            /*      159 = */   "n VOID",
            /*      160 = */   "VOID",
            /*      161 = */   "space",
            /*      162 = */   "n WHITESPACE",
            /*      163 = */   "WHITESPACE",
            /*      164 = */   "str '<wordchar>'",
            /*      165 = */   "n WORDCHAR",
            /*      166 = */   "WORDCHAR",
            /*      167 = */   "str '<xdigit>'",
            /*      168 = */   "n XDIGIT",
            /*      169 = */   "XDIGIT"
        };
        
        /*
         * Grammar Start Expression
         */
        
        static void MAIN (RDE_PARAM p) {
            sym_Grammar (p);
            return;
        }
        
        /*
         * leaf Symbol 'ALNUM'
         */
        
        static void sym_ALNUM (RDE_PARAM p) {
           /*
            * x
            *     "<alnum>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 2)) return ;
            sequence_4 (p);
            rde_param_i_symbol_done_leaf (p, 2, 1);
            return;
        }
        
        static void sequence_4 (RDE_PARAM p) {
           /*
            * x
            *     "<alnum>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<alnum>", 0);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'ALPHA'
         */
        
        static void sym_ALPHA (RDE_PARAM p) {
           /*
            * x
            *     "<alpha>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 5)) return ;
            sequence_9 (p);
            rde_param_i_symbol_done_leaf (p, 5, 4);
            return;
        }
        
        static void sequence_9 (RDE_PARAM p) {
           /*
            * x
            *     "<alpha>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<alpha>", 3);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'AND'
         */
        
        static void sym_AND (RDE_PARAM p) {
           /*
            * x
            *     '&'
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 8)) return ;
            sequence_14 (p);
            rde_param_i_symbol_done_leaf (p, 8, 7);
            return;
        }
        
        static void sequence_14 (RDE_PARAM p) {
           /*
            * x
            *     '&'
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "&", 6);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * void Symbol 'APOSTROPH'
         */
        
        static void sym_APOSTROPH (RDE_PARAM p) {
           /*
            * '''
            */
        
            if (rde_param_i_symbol_void_start (p, 11)) return ;
            rde_param_i_next_char (p, "'", 9);
            rde_param_i_symbol_done_void (p, 11, 10);
            return;
        }
        
        /*
         * leaf Symbol 'ASCII'
         */
        
        static void sym_ASCII (RDE_PARAM p) {
           /*
            * x
            *     "<ascii>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 14)) return ;
            sequence_21 (p);
            rde_param_i_symbol_done_leaf (p, 14, 13);
            return;
        }
        
        static void sequence_21 (RDE_PARAM p) {
           /*
            * x
            *     "<ascii>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<ascii>", 12);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * value Symbol 'Attribute'
         */
        
        static void sym_Attribute (RDE_PARAM p) {
           /*
            * x
            *     /
            *         (VOID)
            *         (LEAF)
            *     (COLON)
            */
        
            if (rde_param_i_symbol_start_d (p, 16)) return ;
            sequence_29 (p);
            rde_param_i_symbol_done_d_reduce (p, 16, 15);
            return;
        }
        
        static void sequence_29 (RDE_PARAM p) {
           /*
            * x
            *     /
            *         (VOID)
            *         (LEAF)
            *     (COLON)
            */
        
            rde_param_i_state_push_value (p);
            choice_26 (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_COLON (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void choice_26 (RDE_PARAM p) {
           /*
            * /
            *     (VOID)
            *     (LEAF)
            */
        
            rde_param_i_state_push_value (p);
            sym_VOID (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_LEAF (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        /*
         * value Symbol 'Char'
         */
        
        static void sym_Char (RDE_PARAM p) {
           /*
            * /
            *     (CharSpecial)
            *     (CharOctalFull)
            *     (CharOctalPart)
            *     (CharUnicode)
            *     (CharUnescaped)
            */
        
            if (rde_param_i_symbol_start_d (p, 18)) return ;
            choice_37 (p);
            rde_param_i_symbol_done_d_reduce (p, 18, 17);
            return;
        }
        
        static void choice_37 (RDE_PARAM p) {
           /*
            * /
            *     (CharSpecial)
            *     (CharOctalFull)
            *     (CharOctalPart)
            *     (CharUnicode)
            *     (CharUnescaped)
            */
        
            rde_param_i_state_push_value (p);
            sym_CharSpecial (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_CharOctalFull (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_CharOctalPart (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_CharUnicode (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_CharUnescaped (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        /*
         * leaf Symbol 'CharOctalFull'
         */
        
        static void sym_CharOctalFull (RDE_PARAM p) {
           /*
            * x
            *     '\'
            *     range (0 .. 2)
            *     range (0 .. 7)
            *     range (0 .. 7)
            */
        
            if (rde_param_i_symbol_start (p, 23)) return ;
            sequence_44 (p);
            rde_param_i_symbol_done_leaf (p, 23, 22);
            return;
        }
        
        static void sequence_44 (RDE_PARAM p) {
           /*
            * x
            *     '\'
            *     range (0 .. 2)
            *     range (0 .. 7)
            *     range (0 .. 7)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "\134", 19);
            if (rde_param_i_seq_void2void(p)) return;
            rde_param_i_next_range (p, "0", "2", 20);
            if (rde_param_i_seq_void2void(p)) return;
            rde_param_i_next_range (p, "0", "7", 21);
            if (rde_param_i_seq_void2void(p)) return;
            rde_param_i_next_range (p, "0", "7", 21);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'CharOctalPart'
         */
        
        static void sym_CharOctalPart (RDE_PARAM p) {
           /*
            * x
            *     '\'
            *     range (0 .. 7)
            *     ?
            *         range (0 .. 7)
            */
        
            if (rde_param_i_symbol_start (p, 25)) return ;
            sequence_52 (p);
            rde_param_i_symbol_done_leaf (p, 25, 24);
            return;
        }
        
        static void sequence_52 (RDE_PARAM p) {
           /*
            * x
            *     '\'
            *     range (0 .. 7)
            *     ?
            *         range (0 .. 7)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "\134", 19);
            if (rde_param_i_seq_void2void(p)) return;
            rde_param_i_next_range (p, "0", "7", 21);
            if (rde_param_i_seq_void2void(p)) return;
            optional_50 (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        static void optional_50 (RDE_PARAM p) {
           /*
            * ?
            *     range (0 .. 7)
            */
        
            rde_param_i_state_push_2 (p);
            rde_param_i_next_range (p, "0", "7", 21);
            rde_param_i_state_merge_ok (p);
            return;
        }
        
        /*
         * leaf Symbol 'CharSpecial'
         */
        
        static void sym_CharSpecial (RDE_PARAM p) {
           /*
            * x
            *     '\'
            *     [nrt'"[]\]
            */
        
            if (rde_param_i_symbol_start (p, 28)) return ;
            sequence_57 (p);
            rde_param_i_symbol_done_leaf (p, 28, 27);
            return;
        }
        
        static void sequence_57 (RDE_PARAM p) {
           /*
            * x
            *     '\'
            *     [nrt'"[]\]
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "\134", 19);
            if (rde_param_i_seq_void2void(p)) return;
            rde_param_i_next_class (p, "nrt'\42\133\135\134", 26);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'CharUnescaped'
         */
        
        static void sym_CharUnescaped (RDE_PARAM p) {
           /*
            * x
            *     !
            *         '\'
            *     <dot>
            */
        
            if (rde_param_i_symbol_start (p, 31)) return ;
            sequence_64 (p);
            rde_param_i_symbol_done_leaf (p, 31, 30);
            return;
        }
        
        static void sequence_64 (RDE_PARAM p) {
           /*
            * x
            *     !
            *         '\'
            *     <dot>
            */
        
            rde_param_i_state_push_void (p);
            notahead_61 (p);
            if (rde_param_i_seq_void2void(p)) return;
            rde_param_i_input_next (p, 29);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        static void notahead_61 (RDE_PARAM p) {
           /*
            * !
            *     '\'
            */
        
            rde_param_i_loc_push (p);
            rde_param_i_next_char (p, "\134", 19);
            rde_param_i_notahead_exit (p);
            return;
        }
        
        /*
         * leaf Symbol 'CharUnicode'
         */
        
        static void sym_CharUnicode (RDE_PARAM p) {
           /*
            * x
            *     "\u"
            *     <xdigit>
            *     ?
            *         x
            *             <xdigit>
            *             ?
            *                 x
            *                     <xdigit>
            *                     ?
            *                         <xdigit>
            */
        
            if (rde_param_i_symbol_start (p, 35)) return ;
            sequence_82 (p);
            rde_param_i_symbol_done_leaf (p, 35, 34);
            return;
        }
        
        static void sequence_82 (RDE_PARAM p) {
           /*
            * x
            *     "\u"
            *     <xdigit>
            *     ?
            *         x
            *             <xdigit>
            *             ?
            *                 x
            *                     <xdigit>
            *                     ?
            *                         <xdigit>
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "\134u", 32);
            if (rde_param_i_seq_void2void(p)) return;
            rde_param_i_next_xdigit (p, 33);
            if (rde_param_i_seq_void2void(p)) return;
            optional_80 (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        static void optional_80 (RDE_PARAM p) {
           /*
            * ?
            *     x
            *         <xdigit>
            *         ?
            *             x
            *                 <xdigit>
            *                 ?
            *                     <xdigit>
            */
        
            rde_param_i_state_push_2 (p);
            sequence_78 (p);
            rde_param_i_state_merge_ok (p);
            return;
        }
        
        static void sequence_78 (RDE_PARAM p) {
           /*
            * x
            *     <xdigit>
            *     ?
            *         x
            *             <xdigit>
            *             ?
            *                 <xdigit>
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_xdigit (p, 33);
            if (rde_param_i_seq_void2void(p)) return;
            optional_76 (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        static void optional_76 (RDE_PARAM p) {
           /*
            * ?
            *     x
            *         <xdigit>
            *         ?
            *             <xdigit>
            */
        
            rde_param_i_state_push_2 (p);
            sequence_74 (p);
            rde_param_i_state_merge_ok (p);
            return;
        }
        
        static void sequence_74 (RDE_PARAM p) {
           /*
            * x
            *     <xdigit>
            *     ?
            *         <xdigit>
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_xdigit (p, 33);
            if (rde_param_i_seq_void2void(p)) return;
            optional_72 (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        static void optional_72 (RDE_PARAM p) {
           /*
            * ?
            *     <xdigit>
            */
        
            rde_param_i_state_push_2 (p);
            rde_param_i_next_xdigit (p, 33);
            rde_param_i_state_merge_ok (p);
            return;
        }
        
        /*
         * value Symbol 'Class'
         */
        
        static void sym_Class (RDE_PARAM p) {
           /*
            * x
            *     (OPENB)
            *     *
            *         x
            *             !
            *                 (CLOSEB)
            *             (Range)
            *     (CLOSEB)
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start_d (p, 37)) return ;
            sequence_96 (p);
            rde_param_i_symbol_done_d_reduce (p, 37, 36);
            return;
        }
        
        static void sequence_96 (RDE_PARAM p) {
           /*
            * x
            *     (OPENB)
            *     *
            *         x
            *             !
            *                 (CLOSEB)
            *             (Range)
            *     (CLOSEB)
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            sym_OPENB (p);
            if (rde_param_i_seq_void2value(p)) return;
            kleene_92 (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_CLOSEB (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void kleene_92 (RDE_PARAM p) {
           /*
            * *
            *     x
            *         !
            *             (CLOSEB)
            *         (Range)
            */
        
            while (1) {
                rde_param_i_state_push_2 (p);
                sequence_90 (p);
                if (rde_param_i_kleene_close(p)) return;
            }
            return;
        }
        
        static void sequence_90 (RDE_PARAM p) {
           /*
            * x
            *     !
            *         (CLOSEB)
            *     (Range)
            */
        
            rde_param_i_state_push_void (p);
            notahead_87 (p);
            if (rde_param_i_seq_void2value(p)) return;
            sym_Range (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void notahead_87 (RDE_PARAM p) {
           /*
            * !
            *     (CLOSEB)
            */
        
            rde_param_i_loc_push (p);
            sym_CLOSEB (p);
            rde_param_i_notahead_exit (p);
            return;
        }
        
        /*
         * void Symbol 'CLOSE'
         */
        
        static void sym_CLOSE (RDE_PARAM p) {
           /*
            * x
            *     '\)'
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_void_start (p, 40)) return ;
            sequence_101 (p);
            rde_param_i_symbol_done_void (p, 40, 39);
            return;
        }
        
        static void sequence_101 (RDE_PARAM p) {
           /*
            * x
            *     '\)'
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "\51", 38);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * void Symbol 'CLOSEB'
         */
        
        static void sym_CLOSEB (RDE_PARAM p) {
           /*
            * ']'
            */
        
            if (rde_param_i_symbol_void_start (p, 43)) return ;
            rde_param_i_next_char (p, "\135", 41);
            rde_param_i_symbol_done_void (p, 43, 42);
            return;
        }
        
        /*
         * void Symbol 'COLON'
         */
        
        static void sym_COLON (RDE_PARAM p) {
           /*
            * x
            *     ':'
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_void_start (p, 46)) return ;
            sequence_108 (p);
            rde_param_i_symbol_done_void (p, 46, 45);
            return;
        }
        
        static void sequence_108 (RDE_PARAM p) {
           /*
            * x
            *     ':'
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, ":", 44);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * void Symbol 'COMMENT'
         */
        
        static void sym_COMMENT (RDE_PARAM p) {
           /*
            * x
            *     '#'
            *     *
            *         x
            *             !
            *                 (EOL)
            *             <dot>
            *     (EOL)
            */
        
            if (rde_param_i_symbol_void_start (p, 49)) return ;
            sequence_121 (p);
            rde_param_i_symbol_done_void (p, 49, 48);
            return;
        }
        
        static void sequence_121 (RDE_PARAM p) {
           /*
            * x
            *     '#'
            *     *
            *         x
            *             !
            *                 (EOL)
            *             <dot>
            *     (EOL)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "#", 47);
            if (rde_param_i_seq_void2void(p)) return;
            kleene_118 (p);
            if (rde_param_i_seq_void2void(p)) return;
            sym_EOL (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        static void kleene_118 (RDE_PARAM p) {
           /*
            * *
            *     x
            *         !
            *             (EOL)
            *         <dot>
            */
        
            while (1) {
                rde_param_i_state_push_2 (p);
                sequence_116 (p);
                if (rde_param_i_kleene_close(p)) return;
            }
            return;
        }
        
        static void sequence_116 (RDE_PARAM p) {
           /*
            * x
            *     !
            *         (EOL)
            *     <dot>
            */
        
            rde_param_i_state_push_void (p);
            notahead_113 (p);
            if (rde_param_i_seq_void2void(p)) return;
            rde_param_i_input_next (p, 29);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        static void notahead_113 (RDE_PARAM p) {
           /*
            * !
            *     (EOL)
            */
        
            rde_param_i_loc_push (p);
            sym_EOL (p);
            rde_param_i_notahead_exit (p);
            return;
        }
        
        /*
         * leaf Symbol 'CONTROL'
         */
        
        static void sym_CONTROL (RDE_PARAM p) {
           /*
            * x
            *     "<control>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 52)) return ;
            sequence_126 (p);
            rde_param_i_symbol_done_leaf (p, 52, 51);
            return;
        }
        
        static void sequence_126 (RDE_PARAM p) {
           /*
            * x
            *     "<control>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<control>", 50);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * void Symbol 'DAPOSTROPH'
         */
        
        static void sym_DAPOSTROPH (RDE_PARAM p) {
           /*
            * '\"'
            */
        
            if (rde_param_i_symbol_void_start (p, 55)) return ;
            rde_param_i_next_char (p, "\42", 53);
            rde_param_i_symbol_done_void (p, 55, 54);
            return;
        }
        
        /*
         * leaf Symbol 'DDIGIT'
         */
        
        static void sym_DDIGIT (RDE_PARAM p) {
           /*
            * x
            *     "<ddigit>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 58)) return ;
            sequence_133 (p);
            rde_param_i_symbol_done_leaf (p, 58, 57);
            return;
        }
        
        static void sequence_133 (RDE_PARAM p) {
           /*
            * x
            *     "<ddigit>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<ddigit>", 56);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * value Symbol 'Definition'
         */
        
        static void sym_Definition (RDE_PARAM p) {
           /*
            * x
            *     ?
            *         (Attribute)
            *     (Identifier)
            *     (IS)
            *     (Expression)
            *     (SEMICOLON)
            */
        
            if (rde_param_i_symbol_start_d (p, 60)) return ;
            sequence_143 (p);
            rde_param_i_symbol_done_d_reduce (p, 60, 59);
            return;
        }
        
        static void sequence_143 (RDE_PARAM p) {
           /*
            * x
            *     ?
            *         (Attribute)
            *     (Identifier)
            *     (IS)
            *     (Expression)
            *     (SEMICOLON)
            */
        
            rde_param_i_state_push_value (p);
            optional_137 (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_Identifier (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_IS (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_Expression (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_SEMICOLON (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void optional_137 (RDE_PARAM p) {
           /*
            * ?
            *     (Attribute)
            */
        
            rde_param_i_state_push_2 (p);
            sym_Attribute (p);
            rde_param_i_state_merge_ok (p);
            return;
        }
        
        /*
         * leaf Symbol 'DIGIT'
         */
        
        static void sym_DIGIT (RDE_PARAM p) {
           /*
            * x
            *     "<digit>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 63)) return ;
            sequence_148 (p);
            rde_param_i_symbol_done_leaf (p, 63, 62);
            return;
        }
        
        static void sequence_148 (RDE_PARAM p) {
           /*
            * x
            *     "<digit>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<digit>", 61);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'DOT'
         */
        
        static void sym_DOT (RDE_PARAM p) {
           /*
            * x
            *     '.'
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 66)) return ;
            sequence_153 (p);
            rde_param_i_symbol_done_leaf (p, 66, 65);
            return;
        }
        
        static void sequence_153 (RDE_PARAM p) {
           /*
            * x
            *     '.'
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, ".", 64);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * void Symbol 'END'
         */
        
        static void sym_END (RDE_PARAM p) {
           /*
            * x
            *     "END"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_void_start (p, 69)) return ;
            sequence_158 (p);
            rde_param_i_symbol_done_void (p, 69, 68);
            return;
        }
        
        static void sequence_158 (RDE_PARAM p) {
           /*
            * x
            *     "END"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "END", 67);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * void Symbol 'EOF'
         */
        
        static void sym_EOF (RDE_PARAM p) {
           /*
            * !
            *     <dot>
            */
        
            if (rde_param_i_symbol_void_start (p, 71)) return ;
            notahead_162 (p);
            rde_param_i_symbol_done_void (p, 71, 70);
            return;
        }
        
        static void notahead_162 (RDE_PARAM p) {
           /*
            * !
            *     <dot>
            */
        
            rde_param_i_loc_push (p);
            rde_param_i_input_next (p, 29);
            rde_param_i_notahead_exit (p);
            return;
        }
        
        /*
         * void Symbol 'EOL'
         */
        
        static void sym_EOL (RDE_PARAM p) {
           /*
            * [
            * ]
            */
        
            if (rde_param_i_symbol_void_start (p, 74)) return ;
            rde_param_i_next_class (p, "\n\r", 72);
            rde_param_i_symbol_done_void (p, 74, 73);
            return;
        }
        
        /*
         * value Symbol 'Expression'
         */
        
        static void sym_Expression (RDE_PARAM p) {
           /*
            * x
            *     (Sequence)
            *     *
            *         x
            *             (SLASH)
            *             (Sequence)
            */
        
            if (rde_param_i_symbol_start_d (p, 76)) return ;
            sequence_174 (p);
            rde_param_i_symbol_done_d_reduce (p, 76, 75);
            return;
        }
        
        static void sequence_174 (RDE_PARAM p) {
           /*
            * x
            *     (Sequence)
            *     *
            *         x
            *             (SLASH)
            *             (Sequence)
            */
        
            rde_param_i_state_push_value (p);
            sym_Sequence (p);
            if (rde_param_i_seq_value2value(p)) return;
            kleene_172 (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void kleene_172 (RDE_PARAM p) {
           /*
            * *
            *     x
            *         (SLASH)
            *         (Sequence)
            */
        
            while (1) {
                rde_param_i_state_push_2 (p);
                sequence_170 (p);
                if (rde_param_i_kleene_close(p)) return;
            }
            return;
        }
        
        static void sequence_170 (RDE_PARAM p) {
           /*
            * x
            *     (SLASH)
            *     (Sequence)
            */
        
            rde_param_i_state_push_void (p);
            sym_SLASH (p);
            if (rde_param_i_seq_void2value(p)) return;
            sym_Sequence (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        /*
         * void Symbol 'Final'
         */
        
        static void sym_Final (RDE_PARAM p) {
           /*
            * x
            *     (END)
            *     (SEMICOLON)
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_void_start (p, 78)) return ;
            sequence_180 (p);
            rde_param_i_symbol_done_void (p, 78, 77);
            return;
        }
        
        static void sequence_180 (RDE_PARAM p) {
           /*
            * x
            *     (END)
            *     (SEMICOLON)
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            sym_END (p);
            if (rde_param_i_seq_void2void(p)) return;
            sym_SEMICOLON (p);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * value Symbol 'Grammar'
         */
        
        static void sym_Grammar (RDE_PARAM p) {
           /*
            * x
            *     (WHITESPACE)
            *     (Header)
            *     *
            *         (Definition)
            *     (Final)
            *     (EOF)
            */
        
            if (rde_param_i_symbol_start_d (p, 80)) return ;
            sequence_190 (p);
            rde_param_i_symbol_done_d_reduce (p, 80, 79);
            return;
        }
        
        static void sequence_190 (RDE_PARAM p) {
           /*
            * x
            *     (WHITESPACE)
            *     (Header)
            *     *
            *         (Definition)
            *     (Final)
            *     (EOF)
            */
        
            rde_param_i_state_push_void (p);
            sym_WHITESPACE (p);
            if (rde_param_i_seq_void2value(p)) return;
            sym_Header (p);
            if (rde_param_i_seq_value2value(p)) return;
            kleene_186 (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_Final (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_EOF (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void kleene_186 (RDE_PARAM p) {
           /*
            * *
            *     (Definition)
            */
        
            while (1) {
                rde_param_i_state_push_2 (p);
                sym_Definition (p);
                if (rde_param_i_kleene_close(p)) return;
            }
            return;
        }
        
        /*
         * leaf Symbol 'GRAPH'
         */
        
        static void sym_GRAPH (RDE_PARAM p) {
           /*
            * x
            *     "<graph>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 83)) return ;
            sequence_195 (p);
            rde_param_i_symbol_done_leaf (p, 83, 82);
            return;
        }
        
        static void sequence_195 (RDE_PARAM p) {
           /*
            * x
            *     "<graph>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<graph>", 81);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * value Symbol 'Header'
         */
        
        static void sym_Header (RDE_PARAM p) {
           /*
            * x
            *     (PEG)
            *     (Identifier)
            *     (StartExpr)
            */
        
            if (rde_param_i_symbol_start_d (p, 85)) return ;
            sequence_201 (p);
            rde_param_i_symbol_done_d_reduce (p, 85, 84);
            return;
        }
        
        static void sequence_201 (RDE_PARAM p) {
           /*
            * x
            *     (PEG)
            *     (Identifier)
            *     (StartExpr)
            */
        
            rde_param_i_state_push_void (p);
            sym_PEG (p);
            if (rde_param_i_seq_void2value(p)) return;
            sym_Identifier (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_StartExpr (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        /*
         * leaf Symbol 'Ident'
         */
        
        static void sym_Ident (RDE_PARAM p) {
           /*
            * x
            *     /
            *         [_:]
            *         <alpha>
            *     *
            *         /
            *             [_:]
            *             <alnum>
            */
        
            if (rde_param_i_symbol_start (p, 90)) return ;
            sequence_214 (p);
            rde_param_i_symbol_done_leaf (p, 90, 89);
            return;
        }
        
        static void sequence_214 (RDE_PARAM p) {
           /*
            * x
            *     /
            *         [_:]
            *         <alpha>
            *     *
            *         /
            *             [_:]
            *             <alnum>
            */
        
            rde_param_i_state_push_void (p);
            choice_206 (p);
            if (rde_param_i_seq_void2void(p)) return;
            kleene_212 (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        static void choice_206 (RDE_PARAM p) {
           /*
            * /
            *     [_:]
            *     <alpha>
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_class (p, "_:", 86);
            if (rde_param_i_bra_void2void(p)) return;
            rde_param_i_next_alpha (p, 87);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        static void kleene_212 (RDE_PARAM p) {
           /*
            * *
            *     /
            *         [_:]
            *         <alnum>
            */
        
            while (1) {
                rde_param_i_state_push_2 (p);
                choice_210 (p);
                if (rde_param_i_kleene_close(p)) return;
            }
            return;
        }
        
        static void choice_210 (RDE_PARAM p) {
           /*
            * /
            *     [_:]
            *     <alnum>
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_class (p, "_:", 86);
            if (rde_param_i_bra_void2void(p)) return;
            rde_param_i_next_alnum (p, 88);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * value Symbol 'Identifier'
         */
        
        static void sym_Identifier (RDE_PARAM p) {
           /*
            * x
            *     (Ident)
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start_d (p, 92)) return ;
            sequence_219 (p);
            rde_param_i_symbol_done_d_reduce (p, 92, 91);
            return;
        }
        
        static void sequence_219 (RDE_PARAM p) {
           /*
            * x
            *     (Ident)
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_value (p);
            sym_Ident (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        /*
         * void Symbol 'IS'
         */
        
        static void sym_IS (RDE_PARAM p) {
           /*
            * x
            *     "<-"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_void_start (p, 95)) return ;
            sequence_224 (p);
            rde_param_i_symbol_done_void (p, 95, 94);
            return;
        }
        
        static void sequence_224 (RDE_PARAM p) {
           /*
            * x
            *     "<-"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<-", 93);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'LEAF'
         */
        
        static void sym_LEAF (RDE_PARAM p) {
           /*
            * x
            *     "leaf"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 98)) return ;
            sequence_229 (p);
            rde_param_i_symbol_done_leaf (p, 98, 97);
            return;
        }
        
        static void sequence_229 (RDE_PARAM p) {
           /*
            * x
            *     "leaf"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "leaf", 96);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * value Symbol 'Literal'
         */
        
        static void sym_Literal (RDE_PARAM p) {
           /*
            * /
            *     x
            *         (APOSTROPH)
            *         *
            *             x
            *                 !
            *                     (APOSTROPH)
            *                 (Char)
            *         (APOSTROPH)
            *         (WHITESPACE)
            *     x
            *         (DAPOSTROPH)
            *         *
            *             x
            *                 !
            *                     (DAPOSTROPH)
            *                 (Char)
            *         (DAPOSTROPH)
            *         (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start_d (p, 100)) return ;
            choice_258 (p);
            rde_param_i_symbol_done_d_reduce (p, 100, 99);
            return;
        }
        
        static void choice_258 (RDE_PARAM p) {
           /*
            * /
            *     x
            *         (APOSTROPH)
            *         *
            *             x
            *                 !
            *                     (APOSTROPH)
            *                 (Char)
            *         (APOSTROPH)
            *         (WHITESPACE)
            *     x
            *         (DAPOSTROPH)
            *         *
            *             x
            *                 !
            *                     (DAPOSTROPH)
            *                 (Char)
            *         (DAPOSTROPH)
            *         (WHITESPACE)
            */
        
            rde_param_i_state_push_value (p);
            sequence_243 (p);
            if (rde_param_i_bra_value2value(p)) return;
            sequence_256 (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void sequence_243 (RDE_PARAM p) {
           /*
            * x
            *     (APOSTROPH)
            *     *
            *         x
            *             !
            *                 (APOSTROPH)
            *             (Char)
            *     (APOSTROPH)
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            sym_APOSTROPH (p);
            if (rde_param_i_seq_void2value(p)) return;
            kleene_239 (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_APOSTROPH (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void kleene_239 (RDE_PARAM p) {
           /*
            * *
            *     x
            *         !
            *             (APOSTROPH)
            *         (Char)
            */
        
            while (1) {
                rde_param_i_state_push_2 (p);
                sequence_237 (p);
                if (rde_param_i_kleene_close(p)) return;
            }
            return;
        }
        
        static void sequence_237 (RDE_PARAM p) {
           /*
            * x
            *     !
            *         (APOSTROPH)
            *     (Char)
            */
        
            rde_param_i_state_push_void (p);
            notahead_234 (p);
            if (rde_param_i_seq_void2value(p)) return;
            sym_Char (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void notahead_234 (RDE_PARAM p) {
           /*
            * !
            *     (APOSTROPH)
            */
        
            rde_param_i_loc_push (p);
            sym_APOSTROPH (p);
            rde_param_i_notahead_exit (p);
            return;
        }
        
        static void sequence_256 (RDE_PARAM p) {
           /*
            * x
            *     (DAPOSTROPH)
            *     *
            *         x
            *             !
            *                 (DAPOSTROPH)
            *             (Char)
            *     (DAPOSTROPH)
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            sym_DAPOSTROPH (p);
            if (rde_param_i_seq_void2value(p)) return;
            kleene_252 (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_DAPOSTROPH (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void kleene_252 (RDE_PARAM p) {
           /*
            * *
            *     x
            *         !
            *             (DAPOSTROPH)
            *         (Char)
            */
        
            while (1) {
                rde_param_i_state_push_2 (p);
                sequence_250 (p);
                if (rde_param_i_kleene_close(p)) return;
            }
            return;
        }
        
        static void sequence_250 (RDE_PARAM p) {
           /*
            * x
            *     !
            *         (DAPOSTROPH)
            *     (Char)
            */
        
            rde_param_i_state_push_void (p);
            notahead_247 (p);
            if (rde_param_i_seq_void2value(p)) return;
            sym_Char (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void notahead_247 (RDE_PARAM p) {
           /*
            * !
            *     (DAPOSTROPH)
            */
        
            rde_param_i_loc_push (p);
            sym_DAPOSTROPH (p);
            rde_param_i_notahead_exit (p);
            return;
        }
        
        /*
         * leaf Symbol 'LOWER'
         */
        
        static void sym_LOWER (RDE_PARAM p) {
           /*
            * x
            *     "<lower>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 103)) return ;
            sequence_263 (p);
            rde_param_i_symbol_done_leaf (p, 103, 102);
            return;
        }
        
        static void sequence_263 (RDE_PARAM p) {
           /*
            * x
            *     "<lower>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<lower>", 101);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'NOT'
         */
        
        static void sym_NOT (RDE_PARAM p) {
           /*
            * x
            *     '!'
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 106)) return ;
            sequence_268 (p);
            rde_param_i_symbol_done_leaf (p, 106, 105);
            return;
        }
        
        static void sequence_268 (RDE_PARAM p) {
           /*
            * x
            *     '!'
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "!", 104);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * void Symbol 'OPEN'
         */
        
        static void sym_OPEN (RDE_PARAM p) {
           /*
            * x
            *     '\('
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_void_start (p, 109)) return ;
            sequence_273 (p);
            rde_param_i_symbol_done_void (p, 109, 108);
            return;
        }
        
        static void sequence_273 (RDE_PARAM p) {
           /*
            * x
            *     '\('
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "\50", 107);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * void Symbol 'OPENB'
         */
        
        static void sym_OPENB (RDE_PARAM p) {
           /*
            * '['
            */
        
            if (rde_param_i_symbol_void_start (p, 112)) return ;
            rde_param_i_next_char (p, "\133", 110);
            rde_param_i_symbol_done_void (p, 112, 111);
            return;
        }
        
        /*
         * void Symbol 'PEG'
         */
        
        static void sym_PEG (RDE_PARAM p) {
           /*
            * x
            *     "PEG"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_void_start (p, 115)) return ;
            sequence_280 (p);
            rde_param_i_symbol_done_void (p, 115, 114);
            return;
        }
        
        static void sequence_280 (RDE_PARAM p) {
           /*
            * x
            *     "PEG"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "PEG", 113);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'PLUS'
         */
        
        static void sym_PLUS (RDE_PARAM p) {
           /*
            * x
            *     '+'
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 118)) return ;
            sequence_285 (p);
            rde_param_i_symbol_done_leaf (p, 118, 117);
            return;
        }
        
        static void sequence_285 (RDE_PARAM p) {
           /*
            * x
            *     '+'
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "+", 116);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * value Symbol 'Prefix'
         */
        
        static void sym_Prefix (RDE_PARAM p) {
           /*
            * x
            *     ?
            *         /
            *             (AND)
            *             (NOT)
            *     (Suffix)
            */
        
            if (rde_param_i_symbol_start_d (p, 120)) return ;
            sequence_295 (p);
            rde_param_i_symbol_done_d_reduce (p, 120, 119);
            return;
        }
        
        static void sequence_295 (RDE_PARAM p) {
           /*
            * x
            *     ?
            *         /
            *             (AND)
            *             (NOT)
            *     (Suffix)
            */
        
            rde_param_i_state_push_value (p);
            optional_292 (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_Suffix (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void optional_292 (RDE_PARAM p) {
           /*
            * ?
            *     /
            *         (AND)
            *         (NOT)
            */
        
            rde_param_i_state_push_2 (p);
            choice_290 (p);
            rde_param_i_state_merge_ok (p);
            return;
        }
        
        static void choice_290 (RDE_PARAM p) {
           /*
            * /
            *     (AND)
            *     (NOT)
            */
        
            rde_param_i_state_push_value (p);
            sym_AND (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_NOT (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        /*
         * value Symbol 'Primary'
         */
        
        static void sym_Primary (RDE_PARAM p) {
           /*
            * /
            *     (ALNUM)
            *     (ALPHA)
            *     (ASCII)
            *     (CONTROL)
            *     (DDIGIT)
            *     (DIGIT)
            *     (GRAPH)
            *     (LOWER)
            *     (PRINTABLE)
            *     (PUNCT)
            *     (SPACE)
            *     (UPPER)
            *     (WORDCHAR)
            *     (XDIGIT)
            *     (Identifier)
            *     x
            *         (OPEN)
            *         (Expression)
            *         (CLOSE)
            *     (Literal)
            *     (Class)
            *     (DOT)
            */
        
            if (rde_param_i_symbol_start_d (p, 122)) return ;
            choice_321 (p);
            rde_param_i_symbol_done_d_reduce (p, 122, 121);
            return;
        }
        
        static void choice_321 (RDE_PARAM p) {
           /*
            * /
            *     (ALNUM)
            *     (ALPHA)
            *     (ASCII)
            *     (CONTROL)
            *     (DDIGIT)
            *     (DIGIT)
            *     (GRAPH)
            *     (LOWER)
            *     (PRINTABLE)
            *     (PUNCT)
            *     (SPACE)
            *     (UPPER)
            *     (WORDCHAR)
            *     (XDIGIT)
            *     (Identifier)
            *     x
            *         (OPEN)
            *         (Expression)
            *         (CLOSE)
            *     (Literal)
            *     (Class)
            *     (DOT)
            */
        
            rde_param_i_state_push_value (p);
            sym_ALNUM (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_ALPHA (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_ASCII (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_CONTROL (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_DDIGIT (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_DIGIT (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_GRAPH (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_LOWER (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_PRINTABLE (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_PUNCT (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_SPACE (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_UPPER (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_WORDCHAR (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_XDIGIT (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_Identifier (p);
            if (rde_param_i_bra_value2value(p)) return;
            sequence_316 (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_Literal (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_Class (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_DOT (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void sequence_316 (RDE_PARAM p) {
           /*
            * x
            *     (OPEN)
            *     (Expression)
            *     (CLOSE)
            */
        
            rde_param_i_state_push_void (p);
            sym_OPEN (p);
            if (rde_param_i_seq_void2value(p)) return;
            sym_Expression (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_CLOSE (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        /*
         * leaf Symbol 'PRINTABLE'
         */
        
        static void sym_PRINTABLE (RDE_PARAM p) {
           /*
            * x
            *     "<print>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 125)) return ;
            sequence_326 (p);
            rde_param_i_symbol_done_leaf (p, 125, 124);
            return;
        }
        
        static void sequence_326 (RDE_PARAM p) {
           /*
            * x
            *     "<print>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<print>", 123);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'PUNCT'
         */
        
        static void sym_PUNCT (RDE_PARAM p) {
           /*
            * x
            *     "<punct>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 128)) return ;
            sequence_331 (p);
            rde_param_i_symbol_done_leaf (p, 128, 127);
            return;
        }
        
        static void sequence_331 (RDE_PARAM p) {
           /*
            * x
            *     "<punct>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<punct>", 126);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'QUESTION'
         */
        
        static void sym_QUESTION (RDE_PARAM p) {
           /*
            * x
            *     '?'
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 131)) return ;
            sequence_336 (p);
            rde_param_i_symbol_done_leaf (p, 131, 130);
            return;
        }
        
        static void sequence_336 (RDE_PARAM p) {
           /*
            * x
            *     '?'
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "?", 129);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * value Symbol 'Range'
         */
        
        static void sym_Range (RDE_PARAM p) {
           /*
            * /
            *     x
            *         (Char)
            *         (TO)
            *         (Char)
            *     (Char)
            */
        
            if (rde_param_i_symbol_start_d (p, 133)) return ;
            choice_345 (p);
            rde_param_i_symbol_done_d_reduce (p, 133, 132);
            return;
        }
        
        static void choice_345 (RDE_PARAM p) {
           /*
            * /
            *     x
            *         (Char)
            *         (TO)
            *         (Char)
            *     (Char)
            */
        
            rde_param_i_state_push_value (p);
            sequence_342 (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_Char (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void sequence_342 (RDE_PARAM p) {
           /*
            * x
            *     (Char)
            *     (TO)
            *     (Char)
            */
        
            rde_param_i_state_push_value (p);
            sym_Char (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_TO (p);
            if (rde_param_i_seq_value2value(p)) return;
            sym_Char (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        /*
         * void Symbol 'SEMICOLON'
         */
        
        static void sym_SEMICOLON (RDE_PARAM p) {
           /*
            * x
            *     ';'
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_void_start (p, 136)) return ;
            sequence_350 (p);
            rde_param_i_symbol_done_void (p, 136, 135);
            return;
        }
        
        static void sequence_350 (RDE_PARAM p) {
           /*
            * x
            *     ';'
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "\73", 134);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * value Symbol 'Sequence'
         */
        
        static void sym_Sequence (RDE_PARAM p) {
           /*
            * +
            *     (Prefix)
            */
        
            if (rde_param_i_symbol_start_d (p, 138)) return ;
            poskleene_354 (p);
            rde_param_i_symbol_done_d_reduce (p, 138, 137);
            return;
        }
        
        static void poskleene_354 (RDE_PARAM p) {
           /*
            * +
            *     (Prefix)
            */
        
            rde_param_i_loc_push (p);
            sym_Prefix (p);
            if (rde_param_i_kleene_abort(p)) return;
            while (1) {
                rde_param_i_state_push_2 (p);
                sym_Prefix (p);
                if (rde_param_i_kleene_close(p)) return;
            }
            return;
        }
        
        /*
         * void Symbol 'SLASH'
         */
        
        static void sym_SLASH (RDE_PARAM p) {
           /*
            * x
            *     '/'
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_void_start (p, 141)) return ;
            sequence_359 (p);
            rde_param_i_symbol_done_void (p, 141, 140);
            return;
        }
        
        static void sequence_359 (RDE_PARAM p) {
           /*
            * x
            *     '/'
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "/", 139);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'SPACE'
         */
        
        static void sym_SPACE (RDE_PARAM p) {
           /*
            * x
            *     "<space>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 144)) return ;
            sequence_364 (p);
            rde_param_i_symbol_done_leaf (p, 144, 143);
            return;
        }
        
        static void sequence_364 (RDE_PARAM p) {
           /*
            * x
            *     "<space>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<space>", 142);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'STAR'
         */
        
        static void sym_STAR (RDE_PARAM p) {
           /*
            * x
            *     '*'
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 147)) return ;
            sequence_369 (p);
            rde_param_i_symbol_done_leaf (p, 147, 146);
            return;
        }
        
        static void sequence_369 (RDE_PARAM p) {
           /*
            * x
            *     '*'
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_char (p, "*", 145);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * value Symbol 'StartExpr'
         */
        
        static void sym_StartExpr (RDE_PARAM p) {
           /*
            * x
            *     (OPEN)
            *     (Expression)
            *     (CLOSE)
            */
        
            if (rde_param_i_symbol_start_d (p, 149)) return ;
            sequence_316 (p);
            rde_param_i_symbol_done_d_reduce (p, 149, 148);
            return;
        }
        
        /*
         * value Symbol 'Suffix'
         */
        
        static void sym_Suffix (RDE_PARAM p) {
           /*
            * x
            *     (Primary)
            *     ?
            *         /
            *             (QUESTION)
            *             (STAR)
            *             (PLUS)
            */
        
            if (rde_param_i_symbol_start_d (p, 151)) return ;
            sequence_385 (p);
            rde_param_i_symbol_done_d_reduce (p, 151, 150);
            return;
        }
        
        static void sequence_385 (RDE_PARAM p) {
           /*
            * x
            *     (Primary)
            *     ?
            *         /
            *             (QUESTION)
            *             (STAR)
            *             (PLUS)
            */
        
            rde_param_i_state_push_value (p);
            sym_Primary (p);
            if (rde_param_i_seq_value2value(p)) return;
            optional_383 (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        static void optional_383 (RDE_PARAM p) {
           /*
            * ?
            *     /
            *         (QUESTION)
            *         (STAR)
            *         (PLUS)
            */
        
            rde_param_i_state_push_2 (p);
            choice_381 (p);
            rde_param_i_state_merge_ok (p);
            return;
        }
        
        static void choice_381 (RDE_PARAM p) {
           /*
            * /
            *     (QUESTION)
            *     (STAR)
            *     (PLUS)
            */
        
            rde_param_i_state_push_value (p);
            sym_QUESTION (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_STAR (p);
            if (rde_param_i_bra_value2value(p)) return;
            sym_PLUS (p);
            rde_param_i_state_merge_value (p);
            return;
        }
        
        /*
         * void Symbol 'TO'
         */
        
        static void sym_TO (RDE_PARAM p) {
           /*
            * '-'
            */
        
            if (rde_param_i_symbol_void_start (p, 154)) return ;
            rde_param_i_next_char (p, "-", 152);
            rde_param_i_symbol_done_void (p, 154, 153);
            return;
        }
        
        /*
         * leaf Symbol 'UPPER'
         */
        
        static void sym_UPPER (RDE_PARAM p) {
           /*
            * x
            *     "<upper>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 157)) return ;
            sequence_392 (p);
            rde_param_i_symbol_done_leaf (p, 157, 156);
            return;
        }
        
        static void sequence_392 (RDE_PARAM p) {
           /*
            * x
            *     "<upper>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<upper>", 155);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'VOID'
         */
        
        static void sym_VOID (RDE_PARAM p) {
           /*
            * x
            *     "void"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 160)) return ;
            sequence_397 (p);
            rde_param_i_symbol_done_leaf (p, 160, 159);
            return;
        }
        
        static void sequence_397 (RDE_PARAM p) {
           /*
            * x
            *     "void"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "void", 158);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * void Symbol 'WHITESPACE'
         */
        
        static void sym_WHITESPACE (RDE_PARAM p) {
           /*
            * *
            *     /
            *         <space>
            *         (COMMENT)
            */
        
            if (rde_param_i_symbol_void_start (p, 163)) return ;
            kleene_404 (p);
            rde_param_i_symbol_done_void (p, 163, 162);
            return;
        }
        
        static void kleene_404 (RDE_PARAM p) {
           /*
            * *
            *     /
            *         <space>
            *         (COMMENT)
            */
        
            while (1) {
                rde_param_i_state_push_2 (p);
                choice_402 (p);
                if (rde_param_i_kleene_close(p)) return;
            }
            return;
        }
        
        static void choice_402 (RDE_PARAM p) {
           /*
            * /
            *     <space>
            *     (COMMENT)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_space (p, 161);
            if (rde_param_i_bra_void2void(p)) return;
            sym_COMMENT (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'WORDCHAR'
         */
        
        static void sym_WORDCHAR (RDE_PARAM p) {
           /*
            * x
            *     "<wordchar>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 166)) return ;
            sequence_409 (p);
            rde_param_i_symbol_done_leaf (p, 166, 165);
            return;
        }
        
        static void sequence_409 (RDE_PARAM p) {
           /*
            * x
            *     "<wordchar>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<wordchar>", 164);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
        /*
         * leaf Symbol 'XDIGIT'
         */
        
        static void sym_XDIGIT (RDE_PARAM p) {
           /*
            * x
            *     "<xdigit>"
            *     (WHITESPACE)
            */
        
            if (rde_param_i_symbol_start (p, 169)) return ;
            sequence_414 (p);
            rde_param_i_symbol_done_leaf (p, 169, 168);
            return;
        }
        
        static void sequence_414 (RDE_PARAM p) {
           /*
            * x
            *     "<xdigit>"
            *     (WHITESPACE)
            */
        
            rde_param_i_state_push_void (p);
            rde_param_i_next_str (p, "<xdigit>", 167);
            if (rde_param_i_seq_void2void(p)) return;
            sym_WHITESPACE (p);
            rde_param_i_state_merge_void (p);
            return;
        }
        
    }

    ## END of GENERATED CODE. DO NOT EDIT.
    # # ## ### ###### ######## #############

    # # ## ### ###### ######## #############
    ## Global PARSER management, per interp

    critcl::ccode {
	/* -*- c -*- */

	typedef struct PARSERg {
	    long int counter;
	    char     buf [50];
	} PARSERg;

	static void
	PARSERgRelease (ClientData cd, Tcl_Interp* interp)
	{
	    ckfree((char*) cd);
	}

	static const char*
	PARSERnewName (Tcl_Interp* interp)
	{
#define KEY "tcllib/parser/pt_parse_peg_c/critcl"

	    Tcl_InterpDeleteProc* proc = PARSERgRelease;
	    PARSERg*                  parserg;

	    parserg = Tcl_GetAssocData (interp, KEY, &proc);
	    if (parserg  == NULL) {
		parserg = (PARSERg*) ckalloc (sizeof (PARSERg));
		parserg->counter = 0;

		Tcl_SetAssocData (interp, KEY, proc,
				  (ClientData) parserg);
	    }

	    parserg->counter ++;
	    sprintf (parserg->buf, "peg%d", parserg->counter);
	    return parserg->buf;
#undef  KEY
	}

	static void
	PARSERdeleteCmd (ClientData clientData)
	{
	    /*
	     * Release the whole PARSER
	     * (Low-level engine only actually).
	     */
	    rde_param_del ((RDE_PARAM) clientData);
	}
    }

    # # ## ### ##### ######## #############
    ## Functions implementing the object methods, and helper.

    critcl::ccode {
	static int  COMPLETE (RDE_PARAM p, Tcl_Interp* interp);

	static int parser_PARSE  (RDE_PARAM p, Tcl_Interp* interp, int objc, Tcl_Obj* CONST* objv)
	{
	    int mode;
	    Tcl_Channel chan;

	    if (objc != 3) {
		Tcl_WrongNumArgs (interp, 2, objv, "chan");
		return TCL_ERROR;
	    }

	    chan = Tcl_GetChannel(interp,
				  Tcl_GetString (objv[2]),
				  &mode);

	    if (!chan) {
		return TCL_ERROR;
	    }

	    rde_param_reset (p, chan);
	    MAIN (p) ; /* Entrypoint for the generated code. */
	    return COMPLETE (p, interp);
	}

	static int parser_PARSET (RDE_PARAM p, Tcl_Interp* interp, int objc, Tcl_Obj* CONST* objv)
	{
	    char* buf;
	    int   len;

	    if (objc != 3) {
		Tcl_WrongNumArgs (interp, 2, objv, "text");
		return TCL_ERROR;
	    }

	    buf = Tcl_GetStringFromObj (objv[2], &len);

	    rde_param_reset (p, NULL);
	    rde_param_data  (p, buf, len);
	    MAIN (p) ; /* Entrypoint for the generated code. */
	    return COMPLETE (p, interp);
	}

	static int COMPLETE (RDE_PARAM p, Tcl_Interp* interp)
	{
	    if (rde_param_query_st (p)) {
		long int  ac;
		Tcl_Obj** av;

		rde_param_query_ast (p, &ac, &av);

		if (ac > 1) {
		    long int  lsc;
		    long int* lsv;
		    Tcl_Obj** lv = NALLOC (3+ac, Tcl_Obj*);

		    rde_param_query_ls (p, &lsc, &lsv);

		    memcpy(lv + 3, av, ac * sizeof (Tcl_Obj*));
		    lv [0] = Tcl_NewObj ();
		    lv [1] = Tcl_NewIntObj (1 + lsv [lsc-1]);
		    lv [2] = Tcl_NewIntObj (rde_param_query_cl (p));

		    Tcl_SetObjResult (interp, Tcl_NewListObj (3, lv));
		    ckfree ((char*) lv);
		} else {
		    Tcl_SetObjResult (interp, av [0]);
		}

		return TCL_OK;
	    } else {
		Tcl_Obj* xv [1];
		const ERROR_STATE* er = rde_param_query_er (p);
		Tcl_Obj* res = rde_param_query_er_tcl (p, er);

		xv [0] = Tcl_NewStringObj ("pt::rde",-1);
		Tcl_ListObjReplace(interp, res, 0, 1, 1, xv);

		Tcl_SetObjResult (interp, res);
		return TCL_ERROR;
	    }
	}
    }

    # # ## ### ##### ######## #############
    ## Object command, method dispatch.

    critcl::ccode {
	static int parser_objcmd (ClientData cd, Tcl_Interp* interp, int objc, Tcl_Obj* CONST* objv)
	{
	    RDE_PARAM p = (RDE_PARAM) cd;
	    int m, res;

	    static CONST char* methods [] = {
		"destroy", "parse", "parset", NULL
	    };
	    enum methods {
		M_DESTROY, M_PARSE, M_PARSET
	    };

	    if (objc < 2) {
		Tcl_WrongNumArgs (interp, objc, objv, "option ?arg arg ...?");
		return TCL_ERROR;
	    } else if (Tcl_GetIndexFromObj (interp, objv [1], methods, "option",
					    0, &m) != TCL_OK) {
		return TCL_ERROR;
	    }

	    /* Dispatch to methods. They check the #args in
	     * detail before performing the requested
	     * functionality
	     */

	    switch (m) {
		case M_DESTROY:
		    if (objc != 2) {
			Tcl_WrongNumArgs (interp, 2, objv, NULL);
			return TCL_ERROR;
		    }

		Tcl_DeleteCommandFromToken(interp, (Tcl_Command) rde_param_query_clientdata (p));
		return TCL_OK;

		case M_PARSE:	res = parser_PARSE  (p, interp, objc, objv); break;
		case M_PARSET:	res = parser_PARSET (p, interp, objc, objv); break;
		default:
		/* Not coming to this place */
		ASSERT (0,"Reached unreachable location");
	    }

	    return res;
	}
    }

    # # ## ### ##### ######## #############
    # Class command, i.e. object construction.

    critcl::ccommand peg_critcl {dummy interp objc objv} {
	/*
	 * Syntax: No arguments beyond the name
	 */

	RDE_PARAM   parser;
	CONST char* name;
	Tcl_Obj*    fqn;
	Tcl_CmdInfo ci;
	Tcl_Command c;

#define USAGE "?name?"

	if ((objc != 2) && (objc != 1)) {
	    Tcl_WrongNumArgs (interp, 1, objv, USAGE);
	    return TCL_ERROR;
	}

	if (objc < 2) {
	    name = PARSERnewName (interp);
	} else {
	    name = Tcl_GetString (objv [1]);
	}

	if (!Tcl_StringMatch (name, "::*")) {
	    /* Relative name. Prefix with current namespace */

	    Tcl_Eval (interp, "namespace current");
	    fqn = Tcl_GetObjResult (interp);
	    fqn = Tcl_DuplicateObj (fqn);
	    Tcl_IncrRefCount (fqn);

	    if (!Tcl_StringMatch (Tcl_GetString (fqn), "::")) {
		Tcl_AppendToObj (fqn, "::", -1);
	    }
	    Tcl_AppendToObj (fqn, name, -1);
	} else {
	    fqn = Tcl_NewStringObj (name, -1);
	    Tcl_IncrRefCount (fqn);
	}
	Tcl_ResetResult (interp);

	if (Tcl_GetCommandInfo (interp,
				Tcl_GetString (fqn),
				&ci)) {
	    Tcl_Obj* err;

	    err = Tcl_NewObj ();
	    Tcl_AppendToObj    (err, "command \"", -1);
	    Tcl_AppendObjToObj (err, fqn);
	    Tcl_AppendToObj    (err, "\" already exists", -1);

	    Tcl_DecrRefCount (fqn);
	    Tcl_SetObjResult (interp, err);
	    return TCL_ERROR;
	}

	parser = rde_param_new (sizeof(p_string)/sizeof(char*), (char**) p_string);
	c = Tcl_CreateObjCommand (interp, Tcl_GetString (fqn),
				  parser_objcmd, (ClientData) parser,
				  PARSERdeleteCmd);
	rde_param_clientdata (parser, (ClientData) c);
	Tcl_SetObjResult (interp, fqn);
	Tcl_DecrRefCount (fqn);
	return TCL_OK;
    }

    ##
    # # ## ### ##### ######## #############
}

# # ## ### ##### ######## ############# #####################
## Ready (Note: Our package provide is at the top).
return
