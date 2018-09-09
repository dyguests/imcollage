function dest = imcollage(filename,segments)
%IMCOLLAGE ��ͼ��ת������ƴ��ƴ�ɵ�ͼ��
%   ��ͼ��ת������ƴ��ƴ�ɵ�ͼ��
% ���룺
%     filename: ԴͼƬ·��
%     segments: �ֶ���
% �����
%     dest: ���ɵ�ͼƬ

% ��ȡͼ������
finfo = imfinfo(filename);
% ��ȡͼ���ļ����洢Ϊ����(width,height,nSamples)
src=imread(filename);

% ͼƬ���
width=finfo.Width;
% ͼƬ�߶�
height=finfo.Height;
% % ͼƬ�ߴ�
% srcSize=[height width];
% ��������RGB����ֵ������Grayһ��ֵ��
nSamples=finfo.NumberOfSamples;

% ƴ����Ŀ��
tileWidth=floor(width/segments);
% ƴ����ĸ߶�
tileHeight=floor(height/segments);
% ƴ����ĳߴ�
tileSize=[tileHeight tileWidth];

% FXIME ��δ����tiles����tiles=[src]
% ����ƴ��ͼ���С��ͼ��tile������֮��Ҫ�ӵĲ���
tile=imresize(src,tileSize);

% ÿ��ͼƬ��ƽ����ɫ
% ���У���(r,c)���ƽ����ɫ��averageColors(r,c),����� grayֵ �� rgb����
% ��ͼ��Ϊ�Ҷȣ���size(averageColors)==[segments,segments,1],��ɫ��Ϊ[segments,segments,3]
averageColors=findAverageColors(src,segments,segments);

% ������ɵ�ͼƬ
dest = zeros(tileHeight*segments,tileWidth*segments,nSamples,'uint8');
% dest = zeros(height,width,nSamples,'uint8'); % ������

% ����tile��ŵ�dest��Ӧ������ȥ
for r=1:segments
    for c=1:segments
        % ��ȡ��ǰ�����Դͼ���Ĭ����ɫ
        averageColor=averageColors(r,c,:);
        
        % ����Ҫӳ��dest������
        rr=((r-1)*tileHeight+1):(r*tileHeight);
        cc=((c-1)*tileWidth+1):(c*tileWidth);
        
        % ��ȡ��Ӧ��ɫ��tile,ӳ�䵽dest��Ӧ������ȥ
        dest(rr,cc,:)=findTile(averageColor,tile);
    end
end

imshow(dest);
% imwrite(ans,'img2reuslt.jpg');

end

function averageColors=findAverageColors(src,rows,columns)
%findAverageColors ����ͼ�����src�ֳ�[rows columns]���ĸ���ƽ����ɫֵ
%   ����ͼ�����src�ֳ�[rows columns]���ĸ���ƽ����ɫֵ
% ���룺
%     src: Դͼ�����
%     rows: ����
%     columns: ����
% �����
%     averageColors: ����ƽ����ɫ����

    srcSize=size(src);
    % ͼƬ���
    width=srcSize(2);
    % ͼƬ�߶�
    height=srcSize(1);
    
    % ƴ����Ŀ��
    tileWidth=floor(width/columns);
    % ƴ����ĸ߶�
    tileHeight=floor(height/rows);

    % ��ȡά����
    ndim=ndims(src);
    % ��ȡ�ò�����
    nSamples=1;
    if ndim==3
        nSamples=srcSize(3);
    end

    % ÿ��ͼƬ��ƽ����ɫ
    % ���У���(r,c)���ƽ����ɫ��averageColors(r,c),����� grayֵ �� rgb����
    averageColors=zeros(rows,columns,nSamples,'uint8');

    % �����ÿ��ͼƬ��ƽ����ɫ
    for r=1:rows
        for c=1:columns
            % ��ȡ�Ӿ��������
            rr=((r-1)*tileHeight+1):(r*tileHeight);
            cc=((c-1)*tileWidth+1):(c*tileWidth);
            
            % �����ȡ��Ӧ������Ӿ��󣨶�Ӧ���ͼ��
            if ndim==3
                partSrc=src(rr,cc,:);
            else
                partSrc=src(rr,cc);
            end
            % ȡƽ��ֵ
            averageColor=mean(mean(partSrc));

            averageColors(r,c,:)=averageColor;
        end
    end
end

function tile=findTile(color,tiles)
%findTile ����color��tiles���ҵ���ƥ���tile
%   ����color��tiles���ҵ���ƥ���tile
% ���룺
%     color: ����ƥ�����ɫ,��Ӧ����һ��1x3�ľ���
%     tiles: Ҫƥ���ͼ�񼯺� % Ŀǰֻ��һ��
% �����
%     tile: ƥ��Ľ��tile

% ��װ���ǻ�ȡ������ƥ��Ľ��
likeTile=tiles;

% likeTile��ƽ����ɫ
likeAverageColor=uint8(mean(mean(likeTile)));

tile = likeTile+(color-likeAverageColor);

end