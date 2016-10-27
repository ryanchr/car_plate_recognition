function y=projection(I,s)
if(s=='h')%水平投影
    y=sum(I');
end
if(s=='v')%垂直投影
    y=sum(I);
end
    
    