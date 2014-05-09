
/* description: Parses end executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
[!<>=]"="|[<>]	      return 'COMPARISON'
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"="		      return '='
"^"                   return '^'
"!"                   return '!'
"%"                   return '%'
"("                   return '('
")"                   return ')'
"IF"		      return 'IF'
"ELSE"		      return 'ELSE'
"PI"                  return 'PI'
"E"                   return 'E'
\w+                   return 'ID'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/'
%left '^'
%right '!'
%right '%'
%left UMINUS

%start expressions

%% /* language grammar */

expressions
    : statement EOF
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          return $1; }
    ;

statement
    : ID COMPARISON e
	{$$ = $3+" "+$1+" "+$2;}
    | ID '=' statement 
	{$$ = $3+" "+'&'+$1+" "+'=';}
    | e
	{$$ = $1;}
    ;
    
e
    : e '+' e
        {$$ = $1+" "+$3+" "+'+';}
    | e '-' e
        {$$ = $1+" "+$3+" "+'-';}
    | e '*' e
        {$$ = $1+" "+$3+" "+'*';}
    | e '/' e
        {$$ = $1+" "+$3+" "+'/';}
    | e '^' e
        {$$ = $1+" "+$3+" "+'^';}
    | e '!'
        {
          $$ = $1+" !";
        }
    | e '%'
        {$$ = $1+" %";}
    | '-' e %prec UMINUS
        {$$ = $2+" NEG";}
    | '(' e ')'
        {$$ = $2;}
    | NUMBER
        {$$ = $1;}
    | E
        {$$ = 'E';}
    | PI
        {$$ = "PI";}
    ;

