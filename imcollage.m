function dest = imcollage(filename,segments)
%IMCOLLAGE 将图像转换成由拼贴拼成的图像
%   将图像转换成由拼贴拼成的图像
% 输入：
%     filename: 源图片路径
%     segments: 分段数
% 输出：
%     dest: 生成的图片

% 获取图像数据
finfo = imfinfo(filename);
% 读取图像文件并存储为矩阵(width,height,nSamples)
src=imread(filename);

% 图片宽度
width=finfo.Width;
% 图片高度
height=finfo.Height;
% % 图片尺寸
% srcSize=[height width];
% 采样数（RGB三个值，还是Gray一个值）
nSamples=finfo.NumberOfSamples;

% 拼贴块的宽度
tileWidth=floor(width/segments);
% 拼贴块的高度
tileHeight=floor(height/segments);
% 拼贴块的尺寸
tileSize=[tileHeight tileWidth];

% FXIME 若未输入tiles，则tiles=[src]
% 用来拼贴图像的小块图像tile，这是之后要加的参数
tile=imresize(src,tileSize);

% 每块图片的平均颜色
% 其中，第(r,c)块的平均颜色是averageColors(r,c),输出是 gray值 或 rgb矩阵
% 若图像为灰度，则size(averageColors)==[segments,segments,1],彩色则为[segments,segments,3]
averageColors=findAverageColors(src,segments,segments);

% 存放生成的图片
dest = zeros(tileHeight*segments,tileWidth*segments,nSamples,'uint8');
% dest = zeros(height,width,nSamples,'uint8'); % 备份用

% 生成tile存放到dest对应区域中去
for r=1:segments
    for c=1:segments
        % 获取当前区域的源图像的默认颜色
        averageColor=averageColors(r,c,:);
        
        % 生成要映射dest的区域
        rr=((r-1)*tileHeight+1):(r*tileHeight);
        cc=((c-1)*tileWidth+1):(c*tileWidth);
        
        % 获取对应颜色的tile,映射到dest对应区域中去
        dest(rr,cc,:)=findTile(averageColor,tile);
    end
end

imshow(dest);
% imwrite(ans,'img2reuslt.jpg');

end

function averageColors=findAverageColors(src,rows,columns)
%findAverageColors 生成图像矩阵src分成[rows columns]块后的各块平均颜色值
%   生成图像矩阵src分成[rows columns]块后的各块平均颜色值
% 输入：
%     src: 源图像矩阵
%     rows: 行数
%     columns: 列数
% 输出：
%     averageColors: 各块平均颜色矩阵

    srcSize=size(src);
    % 图片宽度
    width=srcSize(2);
    % 图片高度
    height=srcSize(1);
    
    % 拼贴块的宽度
    tileWidth=floor(width/columns);
    % 拼贴块的高度
    tileHeight=floor(height/rows);

    % 获取维度数
    ndim=ndims(src);
    % 先取得采样数
    nSamples=1;
    if ndim==3
        nSamples=srcSize(3);
    end

    % 每块图片的平均颜色
    % 其中，第(r,c)块的平均颜色是averageColors(r,c),输出是 gray值 或 rgb矩阵
    averageColors=zeros(rows,columns,nSamples,'uint8');

    % 计算出每块图片的平均颜色
    for r=1:rows
        for c=1:columns
            % 获取子矩阵的区域
            rr=((r-1)*tileHeight+1):(r*tileHeight);
            cc=((c-1)*tileWidth+1):(c*tileWidth);
            
            % 这里获取对应区域的子矩阵（对应块的图像）
            if ndim==3
                partSrc=src(rr,cc,:);
            else
                partSrc=src(rr,cc);
            end
            % 取平均值
            averageColor=mean(mean(partSrc));

            averageColors(r,c,:)=averageColor;
        end
    end
end

function tile=findTile(color,tiles)
%findTile 根据color从tiles中找到最匹配的tile
%   根据color从tiles中找到最匹配的tile
% 输入：
%     color: 需求匹配的颜色,这应该是一个1x3的矩阵
%     tiles: 要匹配的图像集合 % 目前只有一张
% 输出：
%     tile: 匹配的结果tile

% 假装这是获取到的最匹配的结果
likeTile=tiles;

% likeTile的平均颜色
likeAverageColor=uint8(mean(mean(likeTile)));

tile = likeTile+(color-likeAverageColor);

end