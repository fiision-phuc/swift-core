#! /usr/bin/env bash
OUTPUT=$(swiftformat 								\
	--cache ignore 									\
													\
	--indent 4 										\
	--allman false 									\
	--commas inline 								\
	--comments ignore 								\
	--semicolons inline 							\
													\
	--linebreaks lf 								\
													\
	--binarygrouping none 							\
	--decimalgrouping none 							\
	--hexliteralcase lowercase --hexgrouping none 	\
	--octalgrouping none 							\
													\
	--wraparguments afterfirst 						\
	--wrapcollections beforefirst 					\
													\
	--ranges nospace 								\
	--trimwhitespace always 						\
	--disable linebreakAtEndOfFile,hoistPatternLet,strongOutlets,unusedArguments,redundantBackticks,redundantSelf \
	--exclude tooling,Pods,tutorials/tutorial1/Pods,tutorials/tutorial2/Pods,tutorials/tutorial3/Pods,tutorials/tutorial3-rib-di-and-communication-finished/Pods,tutorials/tutorial4/Pods \
./Sources/)

if [ "$OUTPUT" ]; then
  echo "$OUTPUT" >&2
  exit 1
fi
