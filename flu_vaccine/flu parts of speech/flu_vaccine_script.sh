#!/bin/bash

#manually corrected typos - only 2 'l;and' and 'manyof'
#remove all extra tabs in front of each line
echo 'Removing tabs in front of lines...'
sed 's/^ *//g' < flu_vaccine.txt > flu_vaccine_clean.txt
#tokenization
echo 'Tokenizing...'
cat flu_vaccine_clean.txt | tr -cs 'a-zA-Z0-9' '[\n*]' | tr 'A-Z' 'a-z' > flu_vaccine_tokens.txt
#alphabetically organized
echo 'Sorting alphabetically...'
cat flu_vaccine_clean.txt | tr -cs 'a-zA-Z0-9' '[\012*]' | tr A-Z a-z | sort | uniq > flu_vaccine_alph.txt
#sorted based on frequency
echo 'Sorting based on frequency...'
cat flu_vaccine_tokens.txt | sort | uniq -c | sort -rn > flu_vaccine_types.txt

cat flu_vaccine_clean.txt | tr '\r\n' ' ' | tr '[.?!]' '[\n*]' > flu.txt
echo 'creating sentences'
mv flu.txt ./lapos-0.1.2
cat ./lapos-0.1.2/flu.txt | ./lapos-0.1.2/lapos -t -m ./lapos-0.1.2/model_wsj02-21 > flu_vaccine_pos.txt
mv ./lapos-0.1.2/flu.txt ./
cat flu_vaccine_pos.txt | tr -cs '[:alnum:]\/' '[\n*]' > flu_pos_token_list.txt
cat flu_pos_token_list.txt | sort | uniq > flu_pos_types.txt
cat flu_pos_token_list.txt | sort | uniq -c | sort -rn > flu_pos_types_counted.txt


#calculate avgs
echo 'Calculating averages'
cat flu_vaccine.txt | tr '\r\n' ' ' | tr '[.?!]' '[\n*]' | wc | awk '{print "Average sentence length =", $2/$1, "words.", "\nAverage word length = ", $3/$2, "chars.", "\nAverage chars per sentence =", $3/$1, "chars."}' > averages.txt

#2, 3, 4 grams with frequency

echo 'Extracting 2-gram count...'
cat flu_vaccine_clean.txt | tr -cs [a-zA-Z0-9] '[\012*]' | tr 'A-Z' 'a-z' > tmpfile1.txt
tail --lines=+2 tmpfile1.txt > tmpfile2.txt
paste tmpfile1.txt tmpfile2.txt | sort | uniq -c | sort -rn > 2-grams.txt

echo 'Extracting 3-gram count...'
paste tmpfile1.txt tmpfile2.txt > tmpfile3.txt
tail --lines=+3 tmpfile1.txt > tmpfile4.txt
paste tmpfile3.txt tmpfile4.txt | sort | uniq -c | sort -rn > 3-grams.txt

echo 'Extracting 4-gram count...'
tail --lines=+4 tmpfile1.txt > tmpfile5.txt
paste tmpfile3.txt tmpfile4.txt > tmpfile6.txt
paste tmpfile6.txt tmpfile5.txt | sort | uniq -c | sort -rn > 4-grams.txt

mkdir ngram_files
mv tmpfile1.txt tmpfile2.txt tmpfile3.txt tmpfile4.txt tmpfile5.txt tmpfile6.txt ngram_files
echo 'Complete.'