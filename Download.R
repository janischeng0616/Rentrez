#Assignment 5
ncbi_ids <- c("HQ433692.1","HQ433694.1","HQ433691.1") #define ncbi id vectors
library(rentrez) #loading the library
Bburg<-entrez_fetch(db = "nuccore", id = ncbi_ids, rettype = "fasta") #download data of the specific ncbi identifiers on the NCBI database from the nuccore database
#this contains 3 different sequences of the 16S gene of Borrelia burgdorferi (bacteria that causes Lyme Disease)

Bburg #checking it
#they are one after the other and not separated 

Sequences <- strsplit(Bburg, "\n\n") #separating each sequence into an indipendent element
print(Sequences) #makign sure it looks like what we want it to

#the [[1]] at the top means this is a list (strsplit outputs into a list)
Sequences<-unlist(Sequences) #convert this list into not a list
Sequences #take a look at it 

#use regular expressions to separate the sequences from the headers
header<-gsub("(^>.*sequence)\\n[ATCG].*","\\1",Sequences) #look for each sequence and capture the beginning before the sequence starts, make it header
#captures things that start with >. and end with the word "sequence")
#[ATCG] refers to each sequence blurb
seq<-gsub("^>.*sequence\\n([ATCG].*)","\\1",Sequences) #find and capture the actual sequence
Sequences<-data.frame(Name=header,Sequence=seq) #make a dataframe
Sequences #take a look, it has \n new line characters (the sequences are cut into different lines)

#to remove the newline characters:
library(dplyr) #load dplyr
Sequences<- transmute (Sequences, Name, Sequence= gsub ("\\n", "",Sequences$Sequence)) #remaking the columns using dplyr and using regex in it
#so we can apply gsub only to the sequences column and not the entire dataframe
Sequences #check if the newlines disappeared

write.csv(Sequences, "./Sequences.csv",row.names = FALSE) #output this into a file

#from here on it goes onto markdown


