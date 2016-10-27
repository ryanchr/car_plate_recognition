function [y,y1]=idfind(ImageData,h,w)

T=0.5;D=0.05;
y=(ImageData>=T*mean(max(ImageData)));
BW2=bwareaopen(y,10);               %%同图像中移除小于10的对象
SE=strel('square',15);              %%创建15*15的正方形图像块
IM2=imdilate(BW2,SE);               %%膨胀灰度图像BW2，压缩BW2并返回。
IM3=imerode(IM2,SE);                %%通过SE,对IM2进行图像腐蚀,从而可以使字母变细
average=sum(sum(IM3))/(h*w);        %%计算所有像素的总平均值
while(average<0.03||average>0.08)   %%参数可能需要自己调整
   % if(average<=0.005||average>=1)
    %    break;
    %end
    if(average<0.03)
        T=T-D;                      %%若总平均值小于0.03，则T减小D
    else
        T=T+D;                      %%若总平均值大于0.08，则T增加D
    end
    y=(ImageData>=T*mean(max(ImageData)));
    BW2=bwareaopen(y,10);           %%同图像中移除小于10的对象
    IM2=imdilate(BW2,SE);           %%膨胀灰度图像BW2，压缩BW2并返回。
    IM3=imerode(IM2,SE);            %%通过SE,对IM2进行图像腐蚀,从而可以使字母变细
    average=sum(sum(IM3))/(h*w);    %%计算所有像素的总平均值
end
y1=y;
y=IM3;
