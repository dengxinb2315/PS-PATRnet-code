library(ggalluvial)
library(dplyr)
library(ggfittext)

rm(list = ls())

data <- read.csv("all_tb.csv", header = T)
data <- data[order(data$top),]
tf_list <- read.csv("tb_TF_list.csv", header = T)
tf_list <- tf_list[order(tf_list$V1),]
sort(tf_list)
pair_relation <- matrix(data=0,nrow=length(tf_list),ncol = length(tf_list))
for (row in 1:nrow(data)){
  x = match(data[row,]$top,tf_list)
  y = match(data[row,]$bottom,tf_list)
  pair_relation[x,y] = 1
}
sum(pair_relation) ##check the number of pairs

##triple relationship
#M1: Y->X & Y->Z
M1 = data.frame(top=NA,mid=NA,bottom=NA)
count=0
for (x in 1:(length(tf_list)-1)){
  for( y in 1:length(tf_list)){
    if(x!=y & pair_relation[y,x]==1 & pair_relation[x,y]!=1){
      count=count+1
      for(z in (x+1): length(tf_list)){
        if(z!=y && z!=x && pair_relation[y,z]==1 & pair_relation[z,y]!=1 
           & pair_relation[x,z]!=1 & pair_relation[z,x]!=1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M1<-rbind(M1,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_1 <- M1[-1,]
write.csv(Motif_1,file="Motif_1.csv",row.names = FALSE, quote = F)

#M2: X->Y && Z->Y
M2=data.frame(top=NA,mid=NA,bottom=NA)
count2=0
for (x in 1:(length(tf_list)-1)){
  for( y in 1:length(tf_list)){
    if(x!=y && pair_relation[x,y]==1 && pair_relation[y,x]!=1){
      count2=count2+1
      for(z in (x+1): length(tf_list)){
        if(z!=y&&z!=x&&pair_relation[z,y]==1 && pair_relation[y,z]!=1
           && pair_relation[x,z]!=1 && pair_relation[z,x]!=1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M2<-rbind(M2,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_2 <- M2[-1,]
write.csv(Motif_2,file="Motif_2.csv",row.names = FALSE, quote = F)

#M3: X->Y && Y->Z
M3=data.frame(top=NA,mid=NA,bottom=NA)
count3=0
for (x in 1:(length(tf_list))){
  for(y in 1:length(tf_list)){
    if(x!=y && pair_relation[x,y]==1 && pair_relation[y,x]!=1){
      count3=count3+1
      for(z in 1: length(tf_list)){
        if(z!=y&&z!=x&&pair_relation[y,z]==1 && pair_relation[z,y]!=1
           && pair_relation[x,z]!=1 && pair_relation[z,x]!=1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M3<-rbind(M3,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_3 <- M3[-1,]
write.csv(Motif_3,file="Motif_3.csv",row.names = FALSE, quote = F)


#M4: X->Y && Y->Z && Z->X
M4=data.frame(top=NA,mid=NA,bottom=NA)
count4=0
for (x in 1:(length(tf_list)-1)){
  for( y in (x+1):(length(tf_list))){
    if(x!=y && pair_relation[x,y]==1 && pair_relation[y,x]!=1){
      count4=count4+1
      for(z in (x+1): length(tf_list)){
        if(z!=x&&z!=y&&pair_relation[z,x]==1 && pair_relation[x,z]!=1
           && pair_relation[y,z]==1 && pair_relation[z,y]!=1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M4<-rbind(M4,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_4 <- M4[-1,]
write.csv(Motif_4,file="Motif_4.csv",row.names = FALSE, quote = F)

#M5: X->Y && Y->Z && X->Z
M5=data.frame(top=NA,mid=NA,bottom=NA)
count5=0
for (x in 1:length(tf_list)){
  for( y in 1:(length(tf_list)-1)){
    if(x!=y && pair_relation[x,y]==1 && pair_relation[y,x]!=1){
      count5=count5+1
      for(z in (y+1): length(tf_list)){
        if(z!=x&&z!=y&&pair_relation[x,z] ==1 && pair_relation[z,x]!=1
           && pair_relation[y,z]==1 && pair_relation[z,y]!=1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M5<-rbind(M5,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_5 <- M5[-1,]
write.csv(Motif_5,file="Motif_5.csv",row.names = FALSE, quote = F)

#M6: X<->Y && Y->Z
M6=data.frame(top=NA,mid=NA,bottom=NA)
count6=0
for (x in 1:length(tf_list)){
  for( y in 1:length(tf_list)){
    if(x!=y && pair_relation[x,y]==1 && pair_relation[y,x]==1){
      count6=count6+1
      for(z in 1: length(tf_list)){
        if(z!=x&&z!=y&&pair_relation[x,z] !=1 && pair_relation[z,x]!=1
           && pair_relation[y,z]==1 && pair_relation[z,y]!=1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M6<-rbind(M6,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_6 <- M6[-1,]
write.csv(Motif_6,file="Motif_6.csv",row.names = FALSE, quote = F)

#M7: X<->Y && Z->Y
M7=data.frame(top=NA,mid=NA,bottom=NA)
count7=0
for (x in 1:length(tf_list)){
  for( y in 1:length(tf_list)){
    if(x!=y && pair_relation[x,y]==1 && pair_relation[y,x]==1){
      count7=count7+1
      for(z in 1: length(tf_list)){
        if(z!=x&&z!=y&&pair_relation[x,z] !=1 && pair_relation[z,x]!=1
           && pair_relation[y,z]!=1 && pair_relation[z,y]==1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M7<-rbind(M7,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_7 <- M7[-1,]
write.csv(Motif_7,file="Motif_7.csv",row.names = FALSE, quote = F)

#M8: X<->Z && Y->Z && Y->X
M8=data.frame(top=NA,mid=NA,bottom=NA)
count8=0
for (x in 1:(length(tf_list)-1)){
  for( y in 1:length(tf_list)){
    if(x!=y && pair_relation[x,y]!=1 && pair_relation[y,x]==1){
      count8=count8+1
      for(z in (x+1): length(tf_list)){
        if(z!=x&&z!=y&&pair_relation[x,z] ==1 && pair_relation[z,x]==1
           && pair_relation[y,z]==1 && pair_relation[z,y]!=1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M8<-rbind(M8,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_8 <- M8[-1,]
write.csv(Motif_8,file="Motif_8.csv",row.names = FALSE, quote = F)

#M9: X<-Z && Y<->Z && Y<-X
M9=data.frame(top=NA,mid=NA,bottom=NA)
count9=0
for (x in 1:length(tf_list)){
  for( y in 1:length(tf_list)){
    if(x!=y && pair_relation[x,y]==1 && pair_relation[y,x]!=1){
      count9=count9+1
      for(z in 1: length(tf_list)){
        if(z!=x&&z!=y&&pair_relation[x,z]!=1 && pair_relation[z,x]==1
           && pair_relation[y,z]==1 && pair_relation[z,y]==1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M9<-rbind(M9,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_9 <- M9[-1,]
write.csv(Motif_9,file="Motif_9.csv",row.names = FALSE, quote = F)

#M10: X<->Y && Z<->Y
M10=data.frame(top=NA,mid=NA,bottom=NA)
count10=0
for (x in 1:(length(tf_list)-1)){
  for( y in 1:length(tf_list)){
    if(x!=y && pair_relation[x,y]==1 && pair_relation[y,x]==1){
      count10=count10+1
      for(z in (x+1): length(tf_list)){
        if(z!=x&&z!=y&&pair_relation[x,z] !=1 && pair_relation[z,x]!=1
           && pair_relation[y,z]==1 && pair_relation[z,y]==1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M10<-rbind(M10,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_10 <- M10[-1,]
write.csv(Motif_10,file="Motif_10.csv",row.names = FALSE, quote = F)

#M11: X->Y && Z->Y && X<->Z
M11=data.frame(top=NA,mid=NA,bottom=NA)
count11=0
for (x in 1:(length(tf_list)-1)){
  for( y in 1:length(tf_list)){
    if(x!=y && pair_relation[x,y]==1 && pair_relation[y,x]!=1){
      count11=count11+1
      for(z in (x+1): length(tf_list)){
        if(z!=x&&z!=y&&pair_relation[x,z] ==1 && pair_relation[z,x]==1
           && pair_relation[y,z]!=1 && pair_relation[z,y]==1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M11<-rbind(M11,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_11 <- M11[-1,]
write.csv(Motif_11,file="Motif_11.csv",row.names = FALSE, quote = F)

#M12: X->Y && Z<->Y && X<->Z
M12=data.frame(top=NA,mid=NA,bottom=NA)
count12=0
for (x in 1:length(tf_list)){
  for( y in 1:length(tf_list)){
    if(x!=y && pair_relation[x,y]==1 && pair_relation[y,x]!=1){
      count12=count12+1
      for(z in 1: length(tf_list)){
        if(z!=x&&z!=y&&pair_relation[x,z] ==1 && pair_relation[z,x]==1
           && pair_relation[y,z]==1 && pair_relation[z,y]==1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M12<-rbind(M12,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_12 <- M12[-1,]
write.csv(Motif_12,file="Motif_12.csv",row.names = FALSE, quote = F)

#M13: X<->Y && Z<->Y && X<->Z
M13=data.frame(top=NA,mid=NA,bottom=NA)
count13=0
for (x in 1:(length(tf_list)-1)){
  for( y in (x+1):length(tf_list)){
    if(x!=y && pair_relation[x,y]==1 && pair_relation[y,x]==1){
      count13=count13+1
      for(z in (x+1): length(tf_list)){
        if(z!=x&&z!=y&&pair_relation[x,z] ==1 && pair_relation[z,x]==1
           && pair_relation[y,z]==1 && pair_relation[z,y]==1){
          print(c(tf_list[x],tf_list[y],tf_list[z]))
          M13<-rbind(M13,c(tf_list[x],tf_list[y],tf_list[z]))
        }
      }
    }
  }
}
Motif_13 <- M13[-1,]
write.csv(Motif_13,file="Motif_13.csv",row.names = FALSE, quote = F)

##auto-regulators
auto <- data.frame()
for (i in 1:1633) {
  x <- data$top[i]
  y <- data$bottom[i]
  if(x == y){
    m <- cbind(x,y)
    auto <- rbind(auto,m)
  }
}
write.csv(auto,file = "auto-regulators.csv", row.names = F, quote = F)
