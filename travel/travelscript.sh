#!/bin/bash

#manually corrected typos - only 2 'l;and' and 'manyof'
#remove all extra tabs in front of each line
echo 'Removing tabs in front of lines...'
sed 's/^ *//g' < travel.txt > travel_clean.txt
#tokenization
echo 'Tokenizing...'
cat travel_clean.txt | tr -cs 'a-zA-Z0-9' '[\n*]' | tr 'A-Z' 'a-z' > travel_tokens.txt
#alphabetically organized
echo 'Sorting alphabetically...'
cat travel_clean.txt | tr -cs 'a-zA-Z0-9' '[\012*]' | tr A-Z a-z | sort | uniq > travel_alph.txt
#sorted based on frequency
echo 'Sorting based on frequency...'
cat travel_tokens.txt |  sort | uniq -c | sort -rn > travel_types.txt
#2, 3, 4 grams with frequency
echo 'Extracting 2-gram count...'
cat travel_clean.txt | tr -cs [a-zA-Z0-9] '[\012*]' | tr A-Z a-z > tmpfile1.txt
tail +2 tmpfile1.txt > tmpfile2.txt
paste tmpfile1.txt tmpfile2.txt | sort | uniq -c | sort -rn > 2-grams.txt
echo 'Extracting 3-gram count...'
paste tmpfile1.txt tmpfile2.txt > tmpfile3.txt
tail +3 tmpfile1.txt > tmpfile4.txt
paste tmpfile3.txt tmpfile4.txt | sort | uniq -c | sort -rn > 3-grams.txt
echo 'Extracting 4-gram count...'
tail +4 tmpfile1.txt > tmpfile5.txt
paste tmpfile3.txt tmpfile4.txt > tmpfile6.txt
paste tmpfile6.txt tmpfile5.txt | sort | uniq -c | sort -rn > 4-grams.txt
mkdir ngram_files
mv tmpfile1.txt tmpfile2.txt tmpfile3.txt tmpfile4.txt tmpfile5.txt tmpfile6.txt ngram_files

#lapos tagging based on frequency
echo 'Tagging Text..'
cat travel_types.txt | awk '{print $2}' > travel_tmp_types.txt
cp travel_tmp_types.txt ~/Documents/GitHub/cmpt318/lapos-0.1.2/samples
cd ..; cd lapos-0.1.2; ./lapos -m ./model_wsj02-21 < samples/travel_tmp_types.txt > travel_tag.txt
rm  samples/travel_tmp_types.txt
mv travel_tag.txt  ~/Documents/GitHub/cmpt318/travel
cd ..; cd travel;
#filtering content words
echo 'Filtering Content Words...'
grep '/NN' travel_tag.txt > nouns.txt
grep '/VB' travel_tag.txt > verbs.txt
grep '/JJ' travel_tag.txt > adj.txt
grep '/RB' travel_tag.txt > adv.txt
mkdir -p content_words
mv nouns.txt verbs.txt adj.txt adv.txt content_words
echo 'Complete.'
