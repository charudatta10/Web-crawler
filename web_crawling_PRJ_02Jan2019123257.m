clean
%{
https://www.slideshare.net/Mathewvattamala/fpga-implementation-of-utmi-with-usb-2o
%}
a.weblink=cell2mat(inputdlg('start site'));
a.downloaddir=uigetdir();
a.unvisitedweblink={a.weblink};
a.visitedweblink=[];
k=0;
% timer.intial = tic;i=0;
% timer.progress=waitbar(0);
%{
url = 'http://heritage.stsci.edu/2007/14/images/p0714aa.jpg';
filename = 'jupiter_aurora.jpg';
outfilename = websave(filename,url)
%}
while (~isempty(a.unvisitedweblink) && k<10)
    k=k+1;
    a.visitedweblink{k}=a.weblink;%add visited weblink
    if(size(a.unvisitedweblink,2)~=1)
        a.unvisitedweblink=a.unvisitedweblink{1:end-1};
    else
        a.unvisitedweblink={};
    end
    try
        a.htmlwebsite=webread(a.weblink);%read webpage
        exp='href="+\S+\w"|src="+\S+\w"|http://+\S+\w|https://+\S+\w';
        a.link=regexp(a.htmlwebsite,exp,'match')';%image link
        a=trim_link(a);%{src=,,http://,https://}
         for i=1:length(a.src_link)
            z1=regexp(a.src_link{i},'/','split');
            z2=cellfun(@(x)regexp(x, '\S+\w*+(.png|.jpg)','match','once'), z1, 'UniformOutput', false);
            z3=num2str(cell2mat(unique(z2(~cellfun(@isempty, z2)),'first')'));
            websave( z3,a.src_link{i});
         end
         a.unvisitedweblink=a.trim_link;
         a.weblink=a.unvisitedweblink{end};
    catch x
        cprintf('-red',' error has occured \n error identifier  :  %s  \n error mesage   :   %s \n ',...
            x.identifier,x.message)
    end
        %{
         timer.final = toc(timer.intial);
         timer.average = timer.final / length(a.visitedweblink);
         timer.esttimate = length(a.unvisitedweblink) * timer.average;
         timer.esttimatestring = datestr(datenum(0,0,0,0,0,timer.esttimate),'DD:HH:MM:SS');
         waitbar(length(a.visitedweblink)/(length(a.unvisitedweblink)+length(a.visitedweblink)),...
         timer.progress,['wait time',char(timer.esttimatestring) ]);
        %}
end
function a=trim_link(a)
exp='href|=|"||src';
rep='';
for i=1:length(a.link)
    z1=a.link{i};
    z2=regexprep(z1,exp,rep);
   if(isempty(regexp(z2, '^http', 'once')))
       z2=[a.weblink,z2];
   end
     if(~isempty(regexp(z2,'\w+.png|\w+.jpg','once')))
       z3{i}=z2;
       z4{i}={};
     else
         z4{i}=z2;
         z3{i}={};
     end
end
if(~isempty(z3))
a.src_link=unique(z3(~cellfun(@isempty, z3)),'first')';
end
if(~isempty(z4))
a.trim_link=unique(z4(~cellfun(@isempty, z4)),'first')';
end
end

