# CMPT318 Textual Analysis Project
Analyzing text files using various techniques and extracting useful information based on investigation. Our main goals will be to compare *themes, content words, author's diction, structure/style, targeted audience*.

### Corpus
- time machine
- travel
- xab
- 4th files

### Cleaning Up
###### time machine
###### travel
Manually remove errors and fix typos 'l;and' and 'manyof'  
###### xab  
###### 4th file  

### Data Analysis
Analyze by extracting useful information using:  
- tokens  
- types/frequency  
- ngrams  
- content words: Through lapos parts of speech tagging, words are categorized into various types. The following types are ones we are concerned with:
  1. Nouns: singular (NN), plural (NNS), proper singular (NNP), proper plural (NNPS)
  2. Verbs: base form (VB), past tense (VBD), gerund/present participle (VBG), past participle (VBN), single present non-3rd person (VBP), single present 3rd-person (VBZ)
  3. Adjectives: base fore (JJ), comparative (JJR), superlative (JJS)
  4. Adverbs: base form (RB), comparative (RBR), superlative (RBS)

###### time machine

###### travel
Script Execution *travelscript.sh*:  
1. ```chmod +x travelscript.sh```  
2. ```./travelscript.sh```  
What the script does:  
The script removes all extra tabs in front of each line. It then tokenizes the textfile and sorts based on alphabetical order, frequency, and also creates corresponding 2, 3, 4 gram files. *ngram_files* contains all temporary files created during the process for reference. Using POS tagging, the script assigns a type to each word in the text. Once that is complete, filter out and create textfiles based on content words (either nouns, verbs, adjectives, or adverbs) which is placed in the directory *content_words*.

###### xab

###### 4th file
