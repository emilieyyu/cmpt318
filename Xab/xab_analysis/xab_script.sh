#!/bin/bash

## Create a folder for each part of xab
new_dir="`basename $1 .txt`_results"
mkdir -p $new_dir

## Tokenize text and replace de-capitalize all characters
# Note: single dash '-', usually used as part of one word (i.e. ACT-R), is kept.
echo "Tokenizing..."
cat $* | tr -cs 'a-zA-Z0-9/-' '[\012*]' | tr A-Z a-z > tokens.txt

## Extract all types and sort them by frequency
echo "Extracting types..."
cat tokens.txt | sort | uniq -c | sort -rn > types.txt

## Caculate Token/Type ratio
echo "Calculting Token/Type ratio..."
wc -l tokens.txt > tempfile1
wc -l types.txt > tempfile2
paste tempfile1 tempfile2 > token_type_ratio.txt 
awk '{print "Token to type ratio = ", $1/$3, " .\n"}' token_type_ratio.txt
rm -f tempfile1 tempfile2

## Generate n-gram results where n = 2,3,4
cp tokens.txt tmpfile1
echo "Extracting 2-gram count..."
tail -n +2 tmpfile1 > tmpfile2
paste tmpfile1 tmpfile2 | sort | uniq -c | sort -rn > 2-grams.txt
echo "Extracting 3-gram count..."
paste tmpfile1 tmpfile2 > tmpfile3
tail -n +3 tmpfile1 > tmpfile4
paste tmpfile3 tmpfile4 | sort | uniq -c | sort -rn > 3-grams.txt
echo "Extracting 4-gram count..."
tail -n +4 tmpfile1 > tmpfile5
paste tmpfile3 tmpfile4 > tmpfile6
paste tmpfile6 tmpfile5 | sort | uniq -c | sort -rn > 4-grams.txt
rm -f tmpfile1 tmpfile2 tmpfile3 tmpfile4 tmpfile5 tmpfile6

## Identify content words (common nouns): 
# Segment text into sentences -> tag with "Lapos" -> tokenize -> extract types and sort -> grep common nouns.
echo "Tagging text..."
cat $* | tr -cs '[:alnum:]\/\.\?' ' ' | tr '/./?' '\n' > text_sentences.txt
./tagger_v3.sh < text_sentences.txt > tagged_text.txt
cat tagged_text.txt | tr -cs '[:alnum:]\/' '[\012*]' > tagged_tokens.txt
cat tagged_tokens.txt | sort | uniq -c | sort -rn > tagged_types.txt
grep '/NN$' tagged_types.txt > nouns.txt

## Calculate average words per sentence. The script is run on a special cleaned version of Xab. 
echo "Calculating average words per sentence and average characters per word..."
cat xab_clean_sentence.txt |tr '\r\n' ' ' | tr '[.?!]' '[\012*]'|wc|
awk '{print "Average sentence length = ", $2/$1, " words.\n"}'

## Caculate average characters per word.
cat $* |wc| awk '{print "Average word length = " , $3/$2, " chars.\n"}'


echo "Move results to directory: $new_dir"
mv tokens.txt types.txt token_type_ratio.txt 2-grams.txt 3-grams.txt 4-grams.txt $new_dir
mv text_sentences.txt tagged_text.txt tagged_tokens.txt tagged_types.txt nouns.txt $new_dir


