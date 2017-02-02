function corp = loaddata(trainfile)
%
%   LOADREVIEW load review text data from inputfile and return complete
%   data structure.
%
%   Input variable:
%       - trainfile: the address of input file
%       - dicwordnum: number of all unique words in dictionary
%
%   Output variable:
%       - corp: formatted reveiw text
%
%   Date: 12/11/2012


% Count number of file lines
docnum = 0;
dicwordnum=0;
% Fill the doc structure
doc = repmat(struct('id', [],'rate',[] ,'word', [], 'word_id', [],'docwordnum', []), 1, docnum);
corp = struct('doc', doc,'rate',[], 'docnum', docnum, 'dicwordnum', dicwordnum, 'totalwords', 0);

rfd = fopen(trainfile, 'r');
while ~feof(rfd),
    inline = fgetl(rfd);
    docnum = docnum + 1;
    parts = strread(inline, '%s', 'delimiter', ' ');
    corp.doc(docnum).id = docnum;
    corp.doc(docnum).rate= str2num(cell2mat(parts(2)));
    corp.rate(docnum)=corp.doc(docnum).rate;
    
    uniqwordnum = length(parts) - 2;
    corp.doc(docnum).word = repmat(0, 1, uniqwordnum);
    corp.doc(docnum).word_id = repmat(0, 1, uniqwordnum);
    wordnum = 0;    % total number of words in each document, including repeated words
    for i=1:uniqwordnum,
        temp = strread(cell2mat(parts(i+2)), '%d', 'delimiter', ':');
        wordnum = wordnum + temp(2);
        corp.doc(docnum).word_id(i) = temp(1);
        corp.doc(docnum).word(i) = temp(2);
    end
    if (max(corp.doc(docnum).word_id)>dicwordnum)
        dicwordnum=max(corp.doc(docnum).word_id);
    end
    corp.doc(docnum).docwordnum = wordnum;
    corp.totalwords = corp.totalwords + wordnum;
end
corp.docnum=docnum;
corp.dicwordnum=dicwordnum;
fclose(rfd);
