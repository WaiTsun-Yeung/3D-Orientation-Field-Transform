function image=newimread(image)
if isstring(image)||ischar(image) %Check if IMAGE is a filename.
    %Check if the image is 2D, borrowed from imread function. (start)
    [fid, errmsg] = fopen(image, 'r');
    if (fid == -1)

        if ~isempty(dir(image))
            % String 'Too many open files' is from strerror.
            % So, no need for a message catalog.
            if contains(errmsg, 'Too many open files')            
                error(message('MATLAB:imagesci:imread:tooManyOpenFiles', image));
            else
                error(message('MATLAB:imagesci:imread:fileReadPermission', image));
            end
        else
            error(message('MATLAB:imagesci:imread:fileDoesNotExist', image));
        end

    else
        % File exists.  Get full filename.
        fullname = fopen(fid);
        fclose(fid);
    end
    format = imftype(fullname);

    if (isempty(format))
        %Check if it's an MRC file. Borrowed from ReadMRC function (start).
        f=fopen(image,'r','ieee-le');
        % Get the first 10 values, which are integers:
        % nc nr ns mode ncstart nrstart nsstart nx ny nz
        a=fread(f,10,'*int32');
        % Get ready to read the data.
        s.nx=double(a(1));
        s.ny=double(a(2));
        s.nz=double(a(3));
        ndata=s.nx * s.ny * s.nz;
        mode=a(4);
        switch mode
            case 0
                string='*uint8';
            case 1
                string='*int16';
            case 2
                string='*float32';
            case 6
                string='*uint16';
            otherwise
                error(['ReadMRC: unknown data mode: ' num2str(mode)]);
        end
        [~,cnt]=fread(f,ndata,string);
        fclose(f);
        if cnt ~= ndata
            image=vid2vol(image); %The image is a video file.
        else
            %image=ReadMRC(image); %The image is an MRC file.
        end %Check if it's an MRC file. Borrowed from ReadMRC function (end).
    else
        image=imread(image); %The image is an image file.
    end
    %Check if the image is 2D, borrowed from imread function. (end)
    
else
    if ~isnumeric(image)&&~islogical(image)
        error('1st input argument must be a filename, or numeric/logical array.');
    end
end

if ~islogical(image)
    if ndims(image)==3 %Check if the image is a coloured image.
        [~,~,h]=size(image);
        if h==3 %If the image is a coloured image, not a 3D image.
            image=rgb2gray(image);
        end
    else
        if ~ismatrix(image) %Check if the image is a grayscale image.
            error('1st input argument must be a 2D or 3D greyscale or coloured image'); 
            %Error message for neither.
        end
    end
end

if ~isa(image,'uint8')&&~islogical(image)
    %Convert a non-uint8 image into a uint8 image.
    image=im2uint8(image);
end