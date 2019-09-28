function varargout = stampgui(varargin)
% STAMPGUI M-file for stampgui.fig
%      STAMPGUI, by itself, creates a new STAMPGUI or raises the existing
%      singleton*.
%
%      H = STAMPGUI returns the handle to a new STAMPGUI or the handle to
%      the existing singleton*.
%
%      STAMPGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STAMPGUI.M with the given input arguments.
%
%      STAMPGUI('Property','Value',...) creates a new STAMPGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stampgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stampgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stampgui

% Last Modified by GUIDE v2.5 29-Jan-2011 20:18:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stampgui_OpeningFcn, ...
                   'gui_OutputFcn',  @stampgui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before stampgui is made visible.
function stampgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stampgui (see VARARGIN)

% Choose default command line output for stampgui
handles.output = hObject;
handles.pathname = '';
handles.filename = {[]};
handles.page = 0;
% set(handles.listbox1,'String',['a';'b';'c']);
% set(handles.listbox1,'String',[get(handles.listbox1,'String');'d']);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stampgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stampgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn1.
function btn1_Callback(hObject, eventdata, handles)
% hObject    handle to btn1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% ask user to input directory name contain 4 stamp images
[filename, pathname] = uigetfile('*.jpg','Please select stamp image(s)','Multiselect','on');
if pathname ~= 0
    handles.pathname = pathname;
    handles.filename = filename;
    g = horzcat(filename);
    num = numel(g);
    strFile = '';
    if ~iscell(filename)
        set(handles.edit1,'String',[pathname filename]);
        set(handles.edit2,'String',filename);
        handles.page = 1;
        imshow([pathname filename],'Parent',handles.axes1);
    else
        for i = 1:num
            if i == 1
                strFile = filename(i);
            else
                strFile = strcat(strFile,',',filename(i));
            end            
        end
        set(handles.edit1,'String',strcat(pathname,'{',strFile,'}'));
        set(handles.edit2,'String',filename{1});
        handles.page = 1;
        imshow([pathname filename{1}],'Parent',handles.axes1);
    end
    guidata(handles.figure1, handles);
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in btn2.
function btn2_Callback(hObject, eventdata, handles)
% hObject    handle to btn2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
%% load numbers image for template matching in price part
numImg = imread('number1.jpg');
numImg = im2bw(numImg,0.5);
% get the size of numbers 0 in numbers image
nprops = regionprops(numImg,{'BoundingBox'});
rect = nprops(10).BoundingBox;
wn = rect(3); hn = rect(4);
% get the limit area of each number (x, x+width)
itisnumberx = zeros(numel(nprops),2);
for g = 1:numel(nprops)
    temps = nprops(g).BoundingBox;
    itisnumberx(g,1) = temps(1);
    itisnumberx(g,2) = temps(1) + temps(3);
end
%% load letter image for template matching in country part
letImg = imread('letter5.jpg');
letImg = im2bw(letImg,0.2);
% get the size of numbers 0 in numbers image
nprops2 = regionprops(letImg,{'BoundingBox'});
rect2 = nprops2(13).BoundingBox;
wl = rect2(3); hl = rect2(4);
% get the limit area of each character in letter template (x, x+width)
itisletterx = zeros(numel(nprops2),2);
for g = 1:numel(nprops2)
    temps2 = nprops2(g).BoundingBox;
    itisletterx(g,1) = temps2(1);
    itisletterx(g,2) = temps2(1) + temps2(3);
end
%% PART 1: read the price characters
% get selected directory & file(s) name 
pathname = handles.pathname;
filenames = handles.filename;
% variable for string letter and number to be displayed on listbox
xx = cell(1,[]);
% variable for number of letter
numletter = 0;
% default currency
uom = 'sen';
totalValue = 0;
thereisRM = 0;
% if user select a folder
if pathname ~= 0
    filename = cell(1);
    if iscell(filenames) == 0
        filename{1} = filenames;
    else
        filename = filenames;
    end
    numels = numel(filename);
    j = 0;
    imgOutArray = cell(1,[]);
    imgOutArray2 = cell(1,[]);
    cellName = cell(1,[]);
    % get price and country characters
    for i = 1:numels
        try
            nameoffile = strcat(pathname,filename{i});   
            rotatedImg = NormalizeRotation(nameoffile);
%             figure, imshow(rotatedImg)
            [imgOut,uplow] = getCharPrice(rotatedImg);
            imgOut2 = getCharCountry(rotatedImg,uplow);
            j = j+1;
            imgOutArray{1,j} = imgOut;
            imgOutArray2{1,j} = imgOut2;
            cellName{1,j} = filename{i};
        catch 
        end        
    end
    
    % get show/do not show process images
    cVal = get(handles.checkbox1,'Value');
    % plot all stamps, iterate all stamp images
    for u = 1:j
        strFile = cellName{1,u};
        % if checkbox is checked, create a new window for images
        if(cVal == 1)
            h = figure;
            set(h,'name',strFile);
        end
%         clear cellImg cellImg2;
        cellImg = imgOutArray{1,u};  
        cellImg2 = imgOutArray2{1,u};
        % find the tallest chars in price images
        % it is used to determine whether a char is the price number or the currency letter
        nn = numel(cellImg2);
        n = numel(cellImg);
        singleImgHeight = zeros(1,n);
        for r = 1:n
            singleCharImg = cellImg{r};
            singleImgHeight(r) = size(singleCharImg,1);
        end
        % get the maximum height of price chars
        hChar = max(singleImgHeight); 
        % set threshold to differ between letter and number based on the height
        % usually, the currency chars (sen,rm) is 3/4 lower than the
        % number chars
        hthresh = (3/4)*hChar;
        strNum = '';
        % if checkbox is checked, display the stamp image
        if(cVal == 1)
            subplot(3,nn,1:nn), imshow([pathname strFile]);
        end
        % iterate again to perform template matching on price image        
        for r = 1:nn
            if r > n, continue; end
            singleCharImg = cellImg{r};            
            % suppress BW again
            singleCharImg = im2bw(singleCharImg,0.2);
            % if checkbox is checked, display segmentation result images
            if(cVal == 1)
                subplot(3,nn,2*nn+r), imshow(singleCharImg);
            end
            % if the height of char is bigger than threshold, then it is a number
            % perform template matching to number image
            if size(singleCharImg,1) > hthresh                
                % resize so has similar size with the number in number image
                singleCharImg = imresize(singleCharImg,[hn wn]);
                % do template matching for the price
                [x,y] = tempmatching(singleCharImg,numImg);
                for k = 1:numel(nprops)
                    if x > itisnumberx(k,1) && x < itisnumberx(k,2)
                        if k == 10, kk = 0; else kk = k; end
                        if k == 10 && r == 3, kk = 2; end
                        if k == 6 && r == 2, kk = 0; end
                        strNum = strcat(strNum,int2str(kk));
                        break;
                    end 
                end
            else
                % if char height is lower than the threshold, then it is a
                % currency letter
                numletter = numletter + 1;
            end
        end
        % decide the currency based on the number of characters of the letter
        if ~isempty(strNum)
            if numletter == 2
                uom = 'RM';
            else
                uom = 'sen';
            end
        else
            uom = '';
        end
%% PART 2: read the country characterss
        strCo = '';
        strNow = '';
        strPrev = '';
        for r = 1:nn
            singleCharImg2 = cellImg2{r};
            singleCharImg2 = im2bw(singleCharImg2,0.2);
            if(cVal == 1)
                subplot(3,nn,nn+r), imshow(singleCharImg2);
            end
            singleCharImg2 = imresize(singleCharImg2,[hl wl]);
            % do template matching for the country 
            [x,y] = tempmatching(singleCharImg2,letImg);
            % numel(nprops) = number of chars in template letImg (a to z)
            for k = 1:numel(nprops2)
                if x > itisletterx(k,1) && x < itisletterx(k,2)
                    kk = k;
                    % wrong interpretation: l is interpreted as i, then
                    % convert it back to l
                    if(k == 9 && r < 5)
                        kk = 12;
                    % wrong interpretation: y is interpreted as v, then
                    % convert it back to y
                    elseif k == 22
                        kk = 25;
                    % wrong interpretation: i is interpreted as t, then
                    % convert it back to i
                    elseif k == 20
                        kk = 9;
                    end
                    strNow = char(kk+96);
                    % if a double chars interpreted as single char
                    % al is interpreted as o, so convert back to al                    
                    if strcmp(strNow,'o')
                        strNow = 'al';
                    end
                    % al is interpreted as d, so convert back to al                   
                    if strcmp(strNow,'d')
                        strNow = 'al';
                    end
                    % ala is interpreted as w, so convert back to al                   
                    if strcmp(strNow,'w')
                        strNow = 'ala';
                    end
                    if strcmp(strPrev,'a')==1 && strcmp(strNow,'a')
                        strNow = 'la';
                    end
                    strCo = strcat(strCo,strNow);
                    strPrev = strNow;
                    break;
                end 
            end
        end
        % save the price and currency 
        xx{1,u} = [strFile ' : ' strCo ', ' strNum uom];
        % if the price is read
        if ~isempty(strNum)
            % if the currency is sen, then convert it to RM
            if strcmp(uom,'sen') == 1
                Num = str2double(strNum)/100;
                totalValue = totalValue + Num;
            else
                thereisRM = 1;
                totalValue = totalValue + str2double(strNum);
            end
        end
        % reset numletter
        numletter = 0;
    end
    % if there is no price in RM, then convert back to sen
        if thereisRM == 0
        totalValue = totalValue * 100;
        uom = 'SEN';
    else
        uom = 'RM';
    end
    % display price and currency on listbox
    totalValue
    xx{1,u+1} = ['TOTAL PRICE : ' num2str(totalValue) blanks(1) uom];
    set(handles.listbox1,'String',xx');
end


% --- Executes on button press in btn3.
function btn3_Callback(hObject, eventdata, handles)
% hObject    handle to btn3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


% --- Executes on button press in btnPrev.
function btnPrev_Callback(hObject, eventdata, handles)
% hObject    handle to btnPrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.page == 0 || handles.page == 1
    return
end
handles.page = handles.page - 1;
imshow([handles.pathname handles.filename{handles.page}],'Parent',handles.axes1);
set(handles.edit2,'String',handles.filename{handles.page});
guidata(handles.figure1, handles);


% --- Executes on button press in btnNext.
function btnNext_Callback(hObject, eventdata, handles)
% hObject    handle to btnNext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.page == 0
    return
end
if ~iscell(handles.filename)
    return
end
if handles.page == length(handles.filename)
    return
end
handles.page = handles.page + 1;
imshow([handles.pathname handles.filename{handles.page}],'Parent',handles.axes1);
set(handles.edit2,'String',handles.filename{handles.page});
guidata(handles.figure1, handles);


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
