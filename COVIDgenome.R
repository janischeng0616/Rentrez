#Assignemtn 5 part 2

library(rentrez) #loading the library
COVID <-entrez_fetch(dbfrom="gene", id = "NC_045512.2", db="nuccore", rettype = "fasta") #download the SARS-CoV-2 reference genome from Genbank with the accession NC_045512.2 
#download in fasta format
head(COVID) #checking the data and seeing what it contains

COVIDSeq<-gsub("^>.*genome\\n([ATCG].*)","\\1",COVID) #find the actual DNA sequence by capturing only the parts containing ATCG (after the word "genome", the last word in the name)
COVIDSeq<-gsub("\\n", "",COVIDSeq ) #removing all the new line characters so that it is not cut in pieces
COVIDSeq #checking it is in the proper format that we can work with

#The S protein starts at bp position 21,563 and ends at position 25,384, we are trying to extract it
Sprotein = COVIDSeq #take the whole sequence first

#here is my most creative way of doing it with regex, although not the most elegant way out there
for (i in 1:nchar(Sprotein)){ #for loop that runs through every character in the sequence
  if (i < 21563) { #for every time the number is smaller than 21563 (the position where the Sprotein begins)
    Sprotein <- sub("\\w","",Sprotein) #remove one bp from the beginning (first match)
  } else if ( i > 25384) { #for every time the number is lager than 25384 (the position where the Sprotein ends)
    Sprotein <- sub("\\w$", "", Sprotein) #remove one bp from the end
  }
} #this way, every character before and after the target positions are replaced with nothing (therefore, removed)
#other ways of doing it: substr (), DNAstring() in biostrings

Sprotein #look at the sequence
#sprotein should be 3822 bp, checking if it is TRUE or FLASE
nchar(Sprotein) == 3822 #true, that's great

write.csv(Sprotein, "./Sprotein.csv") #save it so I can blast it

#Comment on Blast results:
#This gene was a 100% match for a protein in many isolates of the SARS-COV-19, meaning that this particular gene is conserved within this strain
#This is reasonable as this gene is important for the virulence of the virus, which more or less dictates its "reproduction", therefore an essential function such as this would need to be conserved
#This gene is great for target of vaccines since recognition of this protein by our immune system will be effective for building immune responses against the actual virus

