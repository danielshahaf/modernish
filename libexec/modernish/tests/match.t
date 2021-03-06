#! test/for/moderni/sh
# -*- mode: sh; -*-
# See the file LICENSE in the main modernish directory for the licence.

# Printing characters:
doTest1() {
	title='glob: *'
	match abcde 'a*e'
}
doTest2() {
	title='non-glob: escaped *'
	not match abcde 'a\*e'
}
doTest3() {
	title='glob * matches literal *'
	match 'a*e' 'a*e'
}
doTest4() {
	title='escaped * matches literal *'
	match 'a*e' 'a\*e'
}
doTest5() {
	title='backslash-escaping'
	match 'abc* d?e' '\a\b\c\* \d\?\e'
}
doTest6() {
	title='backslash in bracket pattern'
	match '\' '[abc\\def]'
}
doTest7() {
	title='shell-unsafe chars with "?" glob'
	match x\'\"\)x ?\'\"\)?
}
doTest8() {
	title='quotes in pattern: no special meaning'
	not match a \"a\"
}
doTest9() {
	title='semicolon, space, escaped regular char'
	match 'test; echo hi' '*; \e*'
}
doTest10() {
	title='backslash-escaped backslash'
	match '\' '\\'
}
doTest11() {
	title='dangling final backslash is invalid'
	match '\' '\'
	eq $? 2
}
doTest12() {
	title='backslash-escaped newline'
	match "$CCn" "\\$CCn"
}

# Control characters:
doTest13() {
	title="31 control characters"
	match "ab${CC01}cd" "\a\b${CC01}\c\d" || failmsg="${failmsg-}CC01 "
	match "ab${CC02}cd" "\a\b${CC02}\c\d" || failmsg="${failmsg-}CC02 "
	match "ab${CC03}cd" "\a\b${CC03}\c\d" || failmsg="${failmsg-}CC03 "
	match "ab${CC04}cd" "\a\b${CC04}\c\d" || failmsg="${failmsg-}CC04 "
	match "ab${CC05}cd" "\a\b${CC05}\c\d" || failmsg="${failmsg-}CC05 "
	match "ab${CC06}cd" "\a\b${CC06}\c\d" || failmsg="${failmsg-}CC06 "
	match "ab${CC07}cd" "\a\b${CC07}\c\d" || failmsg="${failmsg-}CC07 "
	match "ab${CC08}cd" "\a\b${CC08}\c\d" || failmsg="${failmsg-}CC08 "
	match "ab${CC09}cd" "\a\b${CC09}\c\d" || failmsg="${failmsg-}CC09 "
	match "ab${CC0A}cd" "\a\b${CC0A}\c\d" || failmsg="${failmsg-}CC0A "
	match "ab${CC0B}cd" "\a\b${CC0B}\c\d" || failmsg="${failmsg-}CC0B "
	match "ab${CC0C}cd" "\a\b${CC0C}\c\d" || failmsg="${failmsg-}CC0C "
	match "ab${CC0D}cd" "\a\b${CC0D}\c\d" || failmsg="${failmsg-}CC0D "
	match "ab${CC0E}cd" "\a\b${CC0E}\c\d" || failmsg="${failmsg-}CC0E "
	match "ab${CC0F}cd" "\a\b${CC0F}\c\d" || failmsg="${failmsg-}CC0F "
	match "ab${CC10}cd" "\a\b${CC10}\c\d" || failmsg="${failmsg-}CC10 "
	match "ab${CC11}cd" "\a\b${CC11}\c\d" || failmsg="${failmsg-}CC11 "
	match "ab${CC12}cd" "\a\b${CC12}\c\d" || failmsg="${failmsg-}CC12 "
	match "ab${CC13}cd" "\a\b${CC13}\c\d" || failmsg="${failmsg-}CC13 "
	match "ab${CC14}cd" "\a\b${CC14}\c\d" || failmsg="${failmsg-}CC14 "
	match "ab${CC15}cd" "\a\b${CC15}\c\d" || failmsg="${failmsg-}CC15 "
	match "ab${CC16}cd" "\a\b${CC16}\c\d" || failmsg="${failmsg-}CC16 "
	match "ab${CC17}cd" "\a\b${CC17}\c\d" || failmsg="${failmsg-}CC17 "
	match "ab${CC18}cd" "\a\b${CC18}\c\d" || failmsg="${failmsg-}CC18 "
	match "ab${CC19}cd" "\a\b${CC19}\c\d" || failmsg="${failmsg-}CC19 "
	match "ab${CC1A}cd" "\a\b${CC1A}\c\d" || failmsg="${failmsg-}CC1A "
	match "ab${CC1B}cd" "\a\b${CC1B}\c\d" || failmsg="${failmsg-}CC1B "
	match "ab${CC1C}cd" "\a\b${CC1C}\c\d" || failmsg="${failmsg-}CC1C "
	match "ab${CC1D}cd" "\a\b${CC1D}\c\d" || failmsg="${failmsg-}CC1D "
	match "ab${CC1E}cd" "\a\b${CC1E}\c\d" || failmsg="${failmsg-}CC1E "
	match "ab${CC1F}cd" "\a\b${CC1F}\c\d" || failmsg="${failmsg-}CC1F "
	not isset failmsg
}

doTest14() {
	title="31 escaped control characters"
	match "ab${CC01}cd" "\a\b\\${CC01}\c\d" || failmsg="${failmsg-}CC01 "
	match "ab${CC02}cd" "\a\b\\${CC02}\c\d" || failmsg="${failmsg-}CC02 "
	match "ab${CC03}cd" "\a\b\\${CC03}\c\d" || failmsg="${failmsg-}CC03 "
	match "ab${CC04}cd" "\a\b\\${CC04}\c\d" || failmsg="${failmsg-}CC04 "
	match "ab${CC05}cd" "\a\b\\${CC05}\c\d" || failmsg="${failmsg-}CC05 "
	match "ab${CC06}cd" "\a\b\\${CC06}\c\d" || failmsg="${failmsg-}CC06 "
	match "ab${CC07}cd" "\a\b\\${CC07}\c\d" || failmsg="${failmsg-}CC07 "
	match "ab${CC08}cd" "\a\b\\${CC08}\c\d" || failmsg="${failmsg-}CC08 "
	match "ab${CC09}cd" "\a\b\\${CC09}\c\d" || failmsg="${failmsg-}CC09 "
	match "ab${CC0A}cd" "\a\b\\${CC0A}\c\d" || failmsg="${failmsg-}CC0A "
	match "ab${CC0B}cd" "\a\b\\${CC0B}\c\d" || failmsg="${failmsg-}CC0B "
	match "ab${CC0C}cd" "\a\b\\${CC0C}\c\d" || failmsg="${failmsg-}CC0C "
	match "ab${CC0D}cd" "\a\b\\${CC0D}\c\d" || failmsg="${failmsg-}CC0D "
	match "ab${CC0E}cd" "\a\b\\${CC0E}\c\d" || failmsg="${failmsg-}CC0E "
	match "ab${CC0F}cd" "\a\b\\${CC0F}\c\d" || failmsg="${failmsg-}CC0F "
	match "ab${CC10}cd" "\a\b\\${CC10}\c\d" || failmsg="${failmsg-}CC10 "
	match "ab${CC11}cd" "\a\b\\${CC11}\c\d" || failmsg="${failmsg-}CC11 "
	match "ab${CC12}cd" "\a\b\\${CC12}\c\d" || failmsg="${failmsg-}CC12 "
	match "ab${CC13}cd" "\a\b\\${CC13}\c\d" || failmsg="${failmsg-}CC13 "
	match "ab${CC14}cd" "\a\b\\${CC14}\c\d" || failmsg="${failmsg-}CC14 "
	match "ab${CC15}cd" "\a\b\\${CC15}\c\d" || failmsg="${failmsg-}CC15 "
	match "ab${CC16}cd" "\a\b\\${CC16}\c\d" || failmsg="${failmsg-}CC16 "
	match "ab${CC17}cd" "\a\b\\${CC17}\c\d" || failmsg="${failmsg-}CC17 "
	match "ab${CC18}cd" "\a\b\\${CC18}\c\d" || failmsg="${failmsg-}CC18 "
	match "ab${CC19}cd" "\a\b\\${CC19}\c\d" || failmsg="${failmsg-}CC19 "
	match "ab${CC1A}cd" "\a\b\\${CC1A}\c\d" || failmsg="${failmsg-}CC1A "
	match "ab${CC1B}cd" "\a\b\\${CC1B}\c\d" || failmsg="${failmsg-}CC1B "
	match "ab${CC1C}cd" "\a\b\\${CC1C}\c\d" || failmsg="${failmsg-}CC1C "
	match "ab${CC1D}cd" "\a\b\\${CC1D}\c\d" || failmsg="${failmsg-}CC1D "
	match "ab${CC1E}cd" "\a\b\\${CC1E}\c\d" || failmsg="${failmsg-}CC1E "
	match "ab${CC1F}cd" "\a\b\\${CC1F}\c\d" || failmsg="${failmsg-}CC1F "
	not isset failmsg
}

lastTest=14
