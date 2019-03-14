#!/bin/bash

#remove all extra tabs in front of each line
echo 'Removing tabs in front of lines...'
sed 's/^ *//g' < time_machine.txt > time_machine_clean.txt

#tokenization
echo 'Tokenizing...'
cat time_machine_clean.txt | tr -cs 'a-zA-Z0-9' '[\n*]' | tr 'A-Z' 'a-z' > time_machine_tokens.txt

#alphabetically organized
echo 'Sorting alphabetically...'
cat time_machine_clean.txt | sort | uniq > time_machine_alph.txt

#sorted based on frequency
echo 'Sorting based on frequency...'
cat time_machine_tokens.txt | sort | uniq -c | sort -rn > time_machine_types.txt

# #calculate token/type ratio
echo 'Calculating token/type ratio'
cat time_machine_tokens.txt | wc | awk '{print $1}' > tmptokens.txt
cat time_machine_alph.txt | wc | awk '{print$1}' >> tmptokens.txt
cat tmptokens.txt | awk 'NR%2{printf "%s ",$0;next;}1' | awk '{print "Number of Tokens =", $1, "\nNumber of Types =", $2, "\nToken/type ratio =", $1/$2}' > time_machine_token_type_ratio.txt
rm -f tmptokens.txt

# calculate avgs
echo 'Calculating averages...'
cat time_machine_clean.txt | tr '\r\n' ' ' | tr '[.?!]' '[\012*]' | wc | awk '{print "Average sentence length =", $2/$1, "words.", "\nAverage word length = ", $3/$2, "chars.", "\nAverage chars per sentence =", $3/$1, "chars."}' > time_machine_averages.txt

#2, 3, 4 grams with frequency
echo 'Extracting 2-gram count...'
cat time_machine_clean.txt | tr -cs 'a-zA-Z0-9' '[\012*]' | tr 'A-Z' 'a-z' > tmpfile1.txt
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