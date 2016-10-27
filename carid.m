%ͼ����γ���ƣ����ƺ����Զ�ʶ��
%���ߣ����ϴ�ѧ ����  QQ:35459893  
%%�������ڴ�ͼ������ȡ�����ƺ��벿��
function [I1,number]=plate_draw(filename)
clear;clc;
close all
  
%%filename='2.jpg';
I=filetype(filename);                     %�����Աຯ����ȡͼ�񣬲�ת��Ϊ�Ҷ�ͼ��


tic                                       %�������У���ʼ��ʱ

[height,width]=size(I);                   %��ȡͼ��߶�
I_edge=zeros(height,width);               %Ԥ����
for i=1:width-1                     
    I_edge(:,i)=abs(I(:,i+1)-I(:,i));     %�õ�ͼ�������еĲ������
end

I_edge=(255/(max(max(I_edge))-min(min(I_edge))))*(I_edge-min(min(I_edge)));     %ͼ��Ԥ����
[I_edge,y1]=id_find(I_edge,height,width); %����id_find����

BW2 = I_edge;%

%%%%%%%%%%%%%%%%һЩ��̬ѧ����
SE=strel('rectangle',[10,10]);           %�õ�һ��10*10�ľ���
IM2=imerode(BW2,SE);                     %��ͼ����и�ʴ
IM2=bwareaopen(IM2,20);                  %ȥ��������е�С����
IM3=imdilate(IM2,SE);                    %����ѹ��
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%ͶӰ�Դ��Թ��Ƴ���λ��
p_h=projection(double(IM3),'h');                %����projection����������ˮƽͶӰ
if(p_h(1)>0)
    p_h=[0,p_h];
end
p_v=projection(double(IM3),'v');                %����projection���������д�ֱͶӰ
if(p_v(1)>0)
    p_v=[0,p_v];
end

%%%%%%
p_h=double((p_h>5));                            %��ˮƽͶӰת��Ϊ˫����
p_h=find(((p_h(1:end-1)-p_h(2:end))~=0));       %�ҵ���������������Ԫ�ص��к�
len_h=length(p_h)/2;                            %�ҵ��м���
%%%%%
p_v=double((p_v>5));                            %����ֱͶӰת��Ϊ˫����
p_v=find(((p_v(1:end-1)-p_v(2:end))~=0));       %�ҵ���������������Ԫ�ص��к�
len_v=length(p_v)/2;                            %�ҵ��м���
%%%%%%%%%%%


%%%%%%%%%%%%%%%%%���Լ��㳵�ƺ�ѡ��
k=1;
for i=1:len_h
    for j=1:len_v
        s=IM3(p_h(2*i-1):p_h(2*i),p_v(2*j-1):p_v(2*j));
        if(mean(mean(s))>0.1)
            p{k}=[p_h(2*i-1),p_h(2*i)+1,p_v(2*j-1),p_v(2*j)+1];
            k=k+1;
        end
    end
end
k=k-1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%��һ����С���ƺ�ѡ��
for i=1:k
   edge_IM3=double(edge(double(IM3(p{i}(1):p{i}(2),p{i}(3):p{i}(4))),'canny'));

   [x,y]=find(edge_IM3==1);
   p{i}=[p{i}(1)+min(x),p{i}(2)-(p{i}(2)-p{i}(1)+1-max(x)),...
         p{i}(3)+min(y),p{i}(4)-(p{i}(4)-p{i}(3)+1-max(y))];
   p_center{i}=[fix((p{i}(1)+p{i}(2))/2),fix((p{i}(3)+p{i}(4))/2)];
   p_ratio(i)=(p{i}(4)-p{i}(3))/(p{i}(2)-p{i}(1));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����������ͱ�����˵����pΪһ��Ԫ�����ڴ��ÿ��ͼ�������Ϻ���������������ꣻ
%��Ÿ�ʽΪ��p{k}=[x1,x2,y1,y2]��x1,x2�ֱ�Ϊ�����꣬y1,y2Ϊ������
%p_centerΪһ��Ԫ,���ڴ��ÿ��ͼ������������,p_center{k}=[x,y];x,y�ֱ�Ϊ��,������
%p_ratioΪһ�����������ͼ���ĳ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%�ϲ��ٽ�����%%%%%%%
%����ж��������ִ�кϲ�
if k>1
    n=0;
    ncount=zeros(1,k);
    for i=1:k-1
        %%%��Ҫ����if�����еı���
        %%%��Ҫ����
        %����Ƿ�����ϲ�����
        if(abs(p{i}(1)+p{i}(2)-p{i+1}(1)-p{i+1}(2))<=height/30&&abs(p{i+1}(3)-p{i}(4))<=width/15)
            p{i+1}(1)=min(p{i}(1),p{i+1}(1));
            p{i+1}(2)=max(p{i}(2),p{i+1}(2));
            p{i+1}(3)=min(p{i}(3),p{i+1}(3));
            p{i+1}(4)=max(p{i}(4),p{i+1}(4));  %���ϲ�
            n=n+1;
            ncount(n)=i+1;
        end
    end
    %����кϲ�������ϲ�����������
    if(n>0)
        d_ncount=ncount(2:n+1)-ncount(1:n);%�����ظ���¼�ٽ��Ķ������
        index=find(d_ncount~=1);
        m=length(index);
        for i=1:m
            pp{i}=p{ncount(index(i))};
            
            %pp_center{i}=p_center{ncount(i)};
            
            %���¼�¼�ϲ�����ı���
            pp_ratio(i)=(pp{i}(4)-pp{i}(3))/(pp{i}(2)-pp{i}(1));     
        end
        p=pp;%���������¼
        p_ratio=pp_ratio; %�������������¼
        clear pp;clear pp_ratio; %������ֱ���
    end
end
k=length(p); %�����������
%%%%%%%%%%%%%%�ϲ�����%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%������������ж��Ƿ�Ϊ��������%%%%%%%%%%%%
m=1;T=0.6*max(p_ratio);%0.8������Ҫ����
for i=1:k
    if(p_ratio(i)>=T&p_ratio(i)<20)
        p1{m}=p{i};
        m=m+1;
    end
end
p=p1;clear p1;
k=m-1;   %����������
%%%%%%%%%%%�ж�����%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%d=zeros(k+1,k+1);
%for i=1:k+1
 %   for j=i+1:k+1
        %d(i,j)=sqrt((p_center{i}(1)-p_center{j}(1))^2+(p_center{i}(2)-p_center{j}(2))^2);
  %  end
%end
%˵��:d���ڴ�ŵ�i,j��ͼ������ĵ�ľ���;

%T=sqrt(height^2+width^2)/10;%��ֵ
%[x,y]=find(d>0&d<T); 
%for i=1:length(x)
%    p{x(i)}(1)=min(p{x(i)}(1),p{y(i)}(1));
%    p{x(i)}(2)=max(p{x(i)}(2),p{y(i)}(2));
%    p{x(i)}(3)=min(p{x(i)}(3),p{y(i)}(3));
%    p{x(i)}(4)=max(p{x(i)}(4),p{y(i)}(4));
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

toc                                  %��ʱ����

clear edge_IM3;clear x; clear y;     % ��ղ��ֱ���

%%%%%%%%%%%%%%%%��ʾ
figure;
subplot(221);imshow(I);
subplot(222);imshow(BW2);
subplot(223);imshow(IM2);
subplot(224);imshow(IM3);

%%%%%%%%%%%%%%%%%��ʾ
figure;
for i=1:k
    subplot(1,k,i);
    index=p{i};
    imshow(I(index(1)-2:index(2),index(3):index(4)));
end
if(k==1)
    imwrite(I(index(1)-2:index(2),index(3):index(4)),'cp.jpg');
end
 %�洢����ͼ��           
%%%%%%%%%%%%%%%%
I1=imread('cp,jpg');
%figure;
%I1=I.*uint8(IM3);imshow(I1)


