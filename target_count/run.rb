File.open("target_count_new.r", "w") do |fout|
	fout.puts %{
predict.targets.lines<-readLines("#{ARGV[1]}"); 
num.comp<-length(predict.targets.lines);
predict.targets<-list();
for(i in 1:num.comp){
  line<-unlist(strsplit(predict.targets.lines[i],"\t"));
  if(length(line)>=2){
    predict.targets[[line[1]]]<-line[2:length(line)];
  }else{
    predict.targets[[line[1]]]<-NA;
  }
}

gene.count<-tapply(rep(1,length(unlist(predict.targets))),unlist(predict.targets),sum);
gene.count<-sort(gene.count,decreasing=T);
ez.id<-as.integer(names(gene.count));
predict.targets.len<-unlist(lapply(predict.targets,length));
predict.targets<-as.array(predict.targets);
gene.order<-sapply(ez.id,function(x){
  res<-lapply(predict.targets,function(y){
    ind<-which(y==x);
    if(length(ind)>0){
      return(ind);
    }else{
      return(0);
    }
  });
  res<-unlist(res);
  res[is.na(res)]<-0;
  return(res)
});
colnames(gene.order)<-ez.id;

library(poibin);
prob<-rep(1,length(ez.id));
pp<-predict.targets.len/#{ARGV[0]};
for(i in 1:length(ez.id)){
  kk<-gene.count[i];
  prob[i]<-1-ppoibin(kk=kk-1, pp=pp) #1-P(X<k)=P(X>=k)
}
prob<-p.adjust(prob,method="BH")
# p.threshold<-0.01;
# selected.gene<-ez.id[prob<p.threshold];
result<-c(ez.id, prob, array(gene.count));
dim(result)<-c(length(prob), 3);

write.table(result,"#{ARGV[2]}",sep="\t",row.names=FALSE,col.names=FALSE);
}
end

system("Rscript #{Dir.pwd}/target_count_new.r")
