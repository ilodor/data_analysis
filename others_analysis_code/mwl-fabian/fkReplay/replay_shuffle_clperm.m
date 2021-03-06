function [radonmax, seed, target_out] = replay_shuffle_clperm( target, info, n, varargin )
%REPLAY_SHUFFLE_CLPERM
%
%

if nargin<3
  help(mfilename)
  return
end

options=struct('seed', [], ...
               'binomialtest', 1, ...
               'binomialpvalue', 0.01, ...
               'shufflevalue', [], ...
               'test_interval', 50, ...
               'engine', []);


options = parseArgs( varargin, options );
radonoptions = struct2param(info.radon);

%set random seed
if ~isempty(options.seed)
  oldseed = rand('seed');
  rand('seed', options.seed);
end

testvalue = target.radonmax;

%initialize significance test
if options.binomialtest
  if isempty(testvalue)
    error('replay_shuffle_clperm:invalidArgument', ['Need a test value for ' ...
                        'significance testing']);
  elseif ~isempty(options.shufflevalue)
    if prob_significance(testvalue,options.shufflevalue)<options.binomialpvalue;
      return
    end
  end
end

radonmax = [];
seed = [];

if nargout>2
  keep_fields = {'segment', 'nbins'};
  flds = fields(target);
  target_out = repmat( rmfield(target, flds( ~ismember( flds, keep_fields ) ) ), ...
                   [n 1] );
end

%create engine
if isempty(options.engine)
    posE = reconstructengine( info.spikes, info.behavior, ...
                              info.engine_options{:} );


    %set position grid
    if ~isempty(info.posgrid) && ~strcmp(posE.grid.grid_1, info.posgrid)
        posE.grid.grid_1 = info.posgrid;
    end
    %set velocity grid
    if ~isempty(info.velgrid) && ~strcmp(posE.grid.grid_2, info.velgrid)
        posE.grid.grid_2 = info.velgrid;
    end

    %set time bin size
    posE.bin.binsize = info.timebin;
    
else
    posE = options.engine;
end

posE.randomizerate.enable = 1;
posE.randomizerate.method = 'swap';
posE.randomizerate.dim = 1;
posE.randomizerate.groupdim = 2;

%posE.randomizebasis.enable = 1;
%posE.randomizebasis.method = 'swap';
%posE.randomizebasis.dim = 3;
%posE.randomizebasis.groupdim = [1 2];
%posE.randomizebasis.adjust = 'max';

posE.viewport = target.segment;

for k=1:n
  
  if options.binomialtest && mod(k,options.test_interval)==0
    if prob_significance(testvalue,[options.shufflevalue;radonmax])<options.binomialpvalue;
      break
    end
  end
  
  seed(k,1) = rand('seed');
  
  %randomize estimate
  reset(posE,'randomizerate');
  %reset(posE,'randomizebasis');

  %compute estimate for all selected segments
  shuffle = execute_core(posE, {'estimate'});
  shuffle = permute( shuffle, [1 3 2]); %permute dimensions
  shuffle = sum(shuffle, 3); %collapse along velocity dimension   
  
  smooth_shuffle = smoothn( shuffle, info.smooth.kernelwidth, info.smooth.spacing, ...
                            'nanexcl', 1, 'correct', info.smooth.smoothcorrect, ...
                            'kernel', info.smooth.smoothkernel, ...
                            'normalize', info.smooth.normalize);
  
  [radon, nn, settings] = padded_radon( smooth_shuffle, radonoptions{:} );
      
  [radonmax(k,1), idx] = max( radon(:) );
      
  if nargout>2
    [idx(1) idx(2)] = ind2sub( size(radon), idx );
    target_out(k).seed=seed(k);
    target_out(k).estimate = shuffle;
    target_out(k).radon = radon;
    target_out(k).radonmax = radonmax(k,1);
    target_out(k).theta = settings.theta;
    target_out(k).rho = settings.rho;
    target_out(k).thetamax = settings.theta( idx(1) );
    target_out(k).rhomax = settings.rho( idx(2) );
    target_out(k).line_columns = squeeze( nn(idx(1),idx(2),:) );  
    target_out(k).score = target_out(k).radonmax ./ target_out(k).nbins;
    target_out(k).projection = padded_projection(smooth_shuffle,...
                                             target_out(k).thetamax, ...
                                             target_out(k).rhomax, ...
                                             radonoptions{:});    
    target_out(k).mode_projection = max(smooth_shuffle)';    
    target_out(k).success = true;
  end
      
end

if nargout>2
  target_out = process_target( info, target_out );
end

%restore previous seed
if ~isempty(options.seed)
  rand('seed',oldseed);
end


function P = prob_significance( val, trials )

%imagine a distribution of shuffle scores
%and p = probability of drawing a shuffle score < real score
%H0: p>=alpha
%H1: p<alpha
%X = # shuffle scores < real score
%then what is the probability of drawing k or fewer shuffle scores
%smaller than the real score, given p=alpha and number of drawings N
%P( X<=k | n=N, p=alpha )

P=1;

%number of trials
N = numel(trials);

if N==0
  return
end

alpha = 1./N;

k = numel( find( trials < val ) );

P = binocdf( k, N, 1-alpha );

%if P<pvalue, then we'll reject H0 and thus the real score is NOT significant

