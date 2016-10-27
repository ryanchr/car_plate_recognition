%%函数用于识别图像文件类型
%%2009.12.21—CR-06006336
function I=filetype(car_image)

type=imfinfo(car_image);
type=type.ColorType;    
%获取图象颜色类型

%类型判断
switch(type)
    case 'truecolor'
        I=rgb2gray(imread(car_image));
    case  'indexed'
        [I,map]=imread(car_image);
        I=ind2gray(I,map);
    otherwise
        I=imread(filename);
end
%%clear car_image;clear type;

