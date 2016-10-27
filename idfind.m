function [y,y1]=idfind(ImageData,h,w)

T=0.5;D=0.05;
y=(ImageData>=T*mean(max(ImageData)));
BW2=bwareaopen(y,10);               %%ͬͼ�����Ƴ�С��10�Ķ���
SE=strel('square',15);              %%����15*15��������ͼ���
IM2=imdilate(BW2,SE);               %%���ͻҶ�ͼ��BW2��ѹ��BW2�����ء�
IM3=imerode(IM2,SE);                %%ͨ��SE,��IM2����ͼ��ʴ,�Ӷ�����ʹ��ĸ��ϸ
average=sum(sum(IM3))/(h*w);        %%�����������ص���ƽ��ֵ
while(average<0.03||average>0.08)   %%����������Ҫ�Լ�����
   % if(average<=0.005||average>=1)
    %    break;
    %end
    if(average<0.03)
        T=T-D;                      %%����ƽ��ֵС��0.03����T��СD
    else
        T=T+D;                      %%����ƽ��ֵ����0.08����T����D
    end
    y=(ImageData>=T*mean(max(ImageData)));
    BW2=bwareaopen(y,10);           %%ͬͼ�����Ƴ�С��10�Ķ���
    IM2=imdilate(BW2,SE);           %%���ͻҶ�ͼ��BW2��ѹ��BW2�����ء�
    IM3=imerode(IM2,SE);            %%ͨ��SE,��IM2����ͼ��ʴ,�Ӷ�����ʹ��ĸ��ϸ
    average=sum(sum(IM3))/(h*w);    %%�����������ص���ƽ��ֵ
end
y1=y;
y=IM3;
