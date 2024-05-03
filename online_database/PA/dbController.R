library('RMySQL')

data<-read.csv(paste0("/home/huangjiadai/huangjiadai1/HJD/PAO1-chip-HH/online_database/Web/HT-SELEX/","PA4227_split.csv"),row.names=NULL)

db_enter <- function (tbName,sourcePath){
  ##Connect Database
  conn <- dbConnect(MySQL(), dbname = "mysql", username="root", password="huangjiadai",host="172.17.0.2")
  
  try({
    files<-list.files(sourcePath)
    
    ##read csv files in the path,only put csv files in the path
    for( x in files ){
      ##read data
      tf_name <- strsplit(x,"_")[[1]][1]
      data <- read.csv(paste0(sourcePath,x),row.names=NULL)
      
      if("row.names" %in% colnames(data)){
        #modify column names
        colnames(data) <- colnames(data)[2:ncol(data)]
        
        #drop last column
        data <- data[1:(ncol(data)-1)]
      }
      colnames(data)[1]<-"tf_ID"
      if(tbName == "HT_SELEX"){
        data<-data[data[,1]==tf_name,]
      }
      else if(tbName == "ChIP_seq"){
        data[,1]<-tf_name
      }
      ##check if table exits
      if(!dbExistsTable(conn,tbName)){
        dbCreateTable(conn,tbName,data)
      }
      check_data<-dbGetQuery(conn,paste0("select * from ", tbName ," where tf_ID = ","'",tf_name,"'"))
      
      if(nrow(check_data)!=0){
        print(paste0("You have write ", tf_name, " into database: ", tbName ))
        next
      }
      else{
        dbWriteTable(conn, tbName, data, append=T,row.names=F)
        print(paste("Add data to table:",tf_name))
      }
    }
  },silent=FALSE
  )
    ##关闭数据库连接
  dbDisconnect(conn)
}


db_enter("HT_SELEX","/home/huangjiadai/huangjiadai1/HJD/PAO1-chip-HH/online_database/Web/HT-SELEX/")

db_enter("ChIP_seq","/home/huangjiadai/huangjiadai1/HJD/PAO1-chip-HH/online_database/Web/ChIP-seq/")


##Connect Database
conn <- dbConnect(MySQL(), dbname = "mysql", username="root", password="huangjiadai",host="172.17.0.2")

##移除表
dbRemoveTable(conn,"HT_SELEX")
dbRemoveTable(conn,"ChIP_seq")
##关闭数据库连接
dbDisconnect(conn)

##读取所有数据
table<-dbReadTable(conn,"ChIP_seq")

summary(table)

##查询
table_desc <- dbGetQuery(conn, "show variables LIKE 'local_infile'")
table_desc <- dbGetQuery(conn, "show tables")

##数据库创建连接数超过上线，关闭所有连接
killDbConnections <- function () {
  
  all_cons <- dbListConnections(MySQL())
  
  print(all_cons)
  
  for(con in all_cons)
    +  dbDisconnect(con)
  
  print(paste(length(all_cons), " connections killed."))
  
}
killDbConnections()
