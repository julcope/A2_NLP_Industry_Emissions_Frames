
# Julia Cope 
# read in the files and merge them and output a csv with my data
#https://github.com/JBGruber/LexisNexisTools/blob/master/README.md 

## libraries and WD ----
rm(list=ls())
library("LexisNexisTools")
setwd("~/GitHub/A2_NLP_Industry_Emissions_Frames")


##make one dataframe for each time period and newspaper
## concatenate into 2 dataframes 
##metadatafor all 
## articles body for all 
## export into 2 csv 

## create a function ---- 
clean_pipeline_LN <- function(folder_path){
  ##create LNT object from path
  lntobject <- lnt_read(x = folder_path, extract_paragraphs = TRUE, convert_date = TRUE, end_keyword = "auto",  file_type = "docx", remove_cover = FALSE)
  ##check for duplicates 
  duplicates_df <- lnt_similarity(LNToutput = lntobject, threshold = 0.95)
  #delete duplicates less than 0.2 different
  duplicates_df <- duplicates_df[duplicates_df$rel_dist < 0.2]
  #re-assign object
  lntobject <- lntobject[!lntobject@meta$ID %in% duplicates_df$ID_duplicate, ]
  
  meta_art_df <- merge(lntobject@meta, lntobject@articles)
  meta_art_df <- meta_art_df[c("ID", "Newspaper", "Date", "Length",  "Section", "Author", "Headline", "Article")]
  
  #meta_para_df <- merge(lntobject@meta, lntobject@paragraphs, by.x = "ID", by.y = "Art_ID")
  #meta_para_df <- meta_para_df[c("ID", "Newspaper", "Date", "Length",  "Section", "Author", "Headline", "Par_ID","Paragraph")]
  
  #return(lntobject)
  return(meta_art_df)
  
}

#arts <- lntobject@articles
#meta <- lntobject@meta
#paras <- lntobject@paragraphs

########assign folder(s) and create article object ----
pressreleases_All <- "C:/Users/julia/OneDrive/Documents/GitHub/A2_NLP_Industry_Emissions_Frames/pressreleases/"
press_release_object <- clean_pipeline_LN(pressreleases_All)
## folder_path <- pressreleases_All




############# drop ID column
press_release_object <- press_release_object[ -c(1) ]

########### write to CSV 
write.csv(press_release_object, "01_pressreleases.csv")
