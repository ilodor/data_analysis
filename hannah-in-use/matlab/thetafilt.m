function y = thetafilt(x)
%theta filters in 4-12
% group delay is 250 samples

persistent Hd;

if isempty(Hd)

    % The following code was used to design the filter coefficients:
    % % FIR Window Bandpass filter designed using the FIR1 function.
    %
    % % All frequency values are in Hz.
    % Fs = 2000;  % Sampling Frequency
    %
    % N    = 500;      % Order
    % Fc1  = 4;        % First Cutoff Frequency
    % Fc2  = 12;       % Second Cutoff Frequency
    % flag = 'scale';  % Sampling Flag
    % % Create the window vector for the design algorithm.
    % win = blackman(N+1);
    %
    % % Calculate the coefficients using the FIR1 function.
    % b  = fir1(N, [Fc1 Fc2]/(Fs/2), 'bandpass', win, flag);

    Hd = dsp.FIRFilter( ...
        'Numerator', [0 6.37217673709085e-10 5.1139178308147e-09 ...
        1.73046203575215e-08 4.1102717826122e-08 8.03987388296356e-08 ...
        1.3905811622373e-07 2.20898460529298e-07 3.29666339883144e-07 ...
        4.69013569366105e-07 6.42473014291437e-07 8.53433914099155e-07 ...
        1.10511673587406e-06 1.40054756918313e-06 1.74253207690144e-06 ...
        2.13362901996496e-06 2.57612337753367e-06 3.07199908786578e-06 ...
        3.62291143927567e-06 4.23015914485707e-06 4.89465613918705e-06 ...
        5.61690313995802e-06 6.39695902240155e-06 7.23441205943757e-06 ...
        8.12835108568961e-06 9.07733664881729e-06 1.0079372217008e-05 ...
        1.11318755169139e-05 1.22316500817784e-05 1.33748570949522e-05 ...
        1.45569876194048e-05 1.57728353091724e-05 1.70164697039055e-05 ...
        1.82812102127652e-05 1.95596008988149e-05 2.08433861797536e-05 ...
        2.21234875652748e-05 2.33899815555057e-05 2.4632078828826e-05 ...
        2.58381048508675e-05 2.69954820396103e-05 2.80907136241954e-05 ...
        2.91093693373276e-05 3.00360730829204e-05 3.08544927219064e-05 ...
        3.15473321198753e-05 3.2096325600377e-05 3.24822349473199e-05 ...
        3.26848490988812e-05 3.26829866736978e-05 3.24545014678198e-05 ...
        3.19762910579523e-05 3.1224308642882e-05 3.01735782506633e-05 ...
        2.87982134341252e-05 2.70714395715377e-05 2.49656198828522e-05 ...
        2.24522852647944e-05 1.95021680402537e-05 1.60852397088714e-05 ...
        1.21707527765076e-05 7.72728673135589e-06 2.72279822390494e-06 ...
        -2.87532450326844e-06 -9.10020290173803e-06 -1.59854050978055e-05 ...
        -2.35648785587394e-05 -3.18728784495713e-05 -4.09438916994148e-05 ...
        -5.08125568108303e-05 -6.15135794607481e-05 -7.30816439568514e-05 ...
        -8.55513206290557e-05 -9.89569692517742e-05 -0.000113332638608957 ...
        -0.0001287119623304 -0.000145128051144483 -0.000162613381709264 ...
        -0.000181199682200634 -0.000200917814853059 -0.000221797655665102 ...
        -0.000243867971498506 -0.000267156294815999 -0.000291688796319052 ...
        -0.000317490155762638 -0.000344583431239397 -0.000372989927240567 ...
        -0.000402729061815448 -0.000433818233164985 -0.000466272686018297 ...
        -0.000500105378153382 -0.000535326847435036 -0.000571945079753823 ...
        -0.000609965378260016 -0.000649390234295436 -0.000690219200434199 ...
        -0.000732448766050416 -0.000776072235836772 -0.000821079611702721 ...
        -0.000867457478484594 -0.000915188893902272 -0.000964253283198183 ...
        -0.00101462633889412 -0.00106627992609986 -0.00111918199380472 ...
        -0.00117329649257858 -0.00122858329910381 -0.00128499814795165 ...
        -0.00134249257100879 -0.00140101384494936 -0.00146050494713648 ...
        -0.00152090452032456 -0.00158214684651925 -0.00164416183033638 ...
        -0.00170687499218407 -0.00177020747157385 -0.00183407604084693 ...
        -0.00189839312958045 -0.00196306685991659 -0.00202800109303346 ...
        -0.00209309548695234 -0.0021582455658497 -0.00222334280101559 ...
        -0.00228827470357216 -0.00235292492903695 -0.00241717339378608 ...
        -0.00248089640344168 -0.00254396679317684 -0.00260625407989911 ...
        -0.00266762462624144 -0.00272794181625608 -0.00278706624267399 ...
        -0.00284485590555826 -0.0029011664221464 -0.00295585124764245 ...
        -0.0030087619066856 -0.00305974823518835 -0.00310865863220359 ...
        -0.00315534032144639 -0.00319963962206343 -0.00324140222821053 ...
        -0.00328047349696687 -0.00331669874408315 -0.00334992354703091 ...
        -0.00337999405479048 -0.0034067573037868 -0.003430061539355 ...
        -0.00344975654209146 -0.00346569395842138 -0.00347772763469045 ...
        -0.0034857139540662 -0.00348951217551448 -0.00348898477409755 ...
        -0.00348399778182353 -0.0034744211282616 -0.00346012898012424 ...
        -0.0034410000790062 -0.00341691807646069 -0.00338777186558603 ...
        -0.00335345590829043 -0.00331387055739999 -0.00326892237277361 ...
        -0.00321852443059023 -0.00316259662497707 -0.00310106596115347 ...
        -0.00303386683927304 -0.002960941328157 -0.00288223942812445 ...
        -0.00279771932214 -0.00270734761451632 -0.00261109955642882 ...
        -0.00250895925752074 -0.00240091988290129 -0.00228698383486476 ...
        -0.00216716291868698 -0.00204147849188515 -0.0019099615963592 ...
        -0.00177265307286666 -0.00162960365731877 -0.00148087405842282 ...
        -0.00132653501623521 -0.00116666734122986 -0.00100136193352942 ...
        -0.000830719781989734 -0.000654851942873219 -0.00047387949789264 ...
        -0.000287933491453939 -9.71548469746586e-05 9.8305737796556e-05 ...
        0.000298287916484509 0.000502621840791068 0.000711128328122354 ...
        0.000923619050013263 0.00113989674117215 0.00135975542891738 ...
        0.0015829806827269 0.00180934988357097 0.0020386325126483 ...
        0.00227059045909602 0.00250497834619484 0.00274154387554261 ...
        0.00298002818862212 0.00322016624514287 0.00346168721749143 ...
        0.00370431490058135 0.00394776813635139 0.00419176125212017 ...
        0.00443600451196642 0.00468020458026695 0.00492406499648894 ...
        0.00516728666030065 0.00540956832603279 0.00565060710549469 ...
        0.00589009897812258 0.00612773930741317 0.00636322336257442 ...
        0.00659624684430596 0.00682650641360547 0.00705370022248353 ...
        0.00727752844545816 0.00749769381069237 0.0077139021296322 ...
        0.00792586282400039 0.00813328944900068 0.00833590021159115 ...
        0.00853341848269054 0.00872557330219051 0.00891209987565845 ...
        0.00909274006162944 0.00926724284840388 0.00943536481928661 ...
        0.00959687060522652 0.00975153332384073 0.00989913500383557 ...
        0.010039466993867 0.0101723303549163 0.0102975362352911 ...
        0.0104149062274027 0.0105242727055049 0.010625479143628 ...
        0.0107183804129805 0.0108028430581393 0.0108787455513975 ...
        0.0109459785246847 0.0110044449785301 0.0110540604675877 ...
        0.0110947532622971 0.0111264644863081 0.0111491482293543 ...
        0.011162771635313 0.0111673149652515 0.011162771635313 ...
        0.0111491482293543 0.0111264644863081 0.0110947532622971 ...
        0.0110540604675877 0.0110044449785301 0.0109459785246847 ...
        0.0108787455513975 0.0108028430581393 0.0107183804129805 ...
        0.010625479143628 0.0105242727055049 0.0104149062274027 ...
        0.0102975362352911 0.0101723303549163 0.010039466993867 ...
        0.00989913500383557 0.00975153332384073 0.00959687060522652 ...
        0.00943536481928661 0.00926724284840388 0.00909274006162944 ...
        0.00891209987565845 0.00872557330219051 0.00853341848269054 ...
        0.00833590021159115 0.00813328944900068 0.00792586282400039 ...
        0.0077139021296322 0.00749769381069237 0.00727752844545816 ...
        0.00705370022248353 0.00682650641360547 0.00659624684430596 ...
        0.00636322336257442 0.00612773930741317 0.00589009897812258 ...
        0.00565060710549469 0.00540956832603279 0.00516728666030065 ...
        0.00492406499648894 0.00468020458026695 0.00443600451196642 ...
        0.00419176125212017 0.00394776813635139 0.00370431490058135 ...
        0.00346168721749143 0.00322016624514287 0.00298002818862212 ...
        0.00274154387554261 0.00250497834619484 0.00227059045909602 ...
        0.0020386325126483 0.00180934988357097 0.0015829806827269 ...
        0.00135975542891738 0.00113989674117215 0.000923619050013263 ...
        0.000711128328122354 0.000502621840791068 0.000298287916484509 ...
        9.8305737796556e-05 -9.71548469746586e-05 -0.000287933491453939 ...
        -0.00047387949789264 -0.000654851942873219 -0.000830719781989734 ...
        -0.00100136193352942 -0.00116666734122986 -0.00132653501623521 ...
        -0.00148087405842282 -0.00162960365731877 -0.00177265307286666 ...
        -0.0019099615963592 -0.00204147849188515 -0.00216716291868698 ...
        -0.00228698383486476 -0.00240091988290129 -0.00250895925752074 ...
        -0.00261109955642882 -0.00270734761451632 -0.00279771932214 ...
        -0.00288223942812445 -0.002960941328157 -0.00303386683927304 ...
        -0.00310106596115347 -0.00316259662497707 -0.00321852443059023 ...
        -0.00326892237277361 -0.00331387055739999 -0.00335345590829043 ...
        -0.00338777186558603 -0.00341691807646069 -0.0034410000790062 ...
        -0.00346012898012424 -0.0034744211282616 -0.00348399778182353 ...
        -0.00348898477409755 -0.00348951217551448 -0.0034857139540662 ...
        -0.00347772763469045 -0.00346569395842138 -0.00344975654209146 ...
        -0.003430061539355 -0.0034067573037868 -0.00337999405479048 ...
        -0.00334992354703091 -0.00331669874408315 -0.00328047349696687 ...
        -0.00324140222821053 -0.00319963962206343 -0.00315534032144639 ...
        -0.00310865863220359 -0.00305974823518835 -0.0030087619066856 ...
        -0.00295585124764245 -0.0029011664221464 -0.00284485590555826 ...
        -0.00278706624267399 -0.00272794181625608 -0.00266762462624144 ...
        -0.00260625407989911 -0.00254396679317684 -0.00248089640344168 ...
        -0.00241717339378608 -0.00235292492903695 -0.00228827470357216 ...
        -0.00222334280101559 -0.0021582455658497 -0.00209309548695234 ...
        -0.00202800109303346 -0.00196306685991659 -0.00189839312958045 ...
        -0.00183407604084693 -0.00177020747157385 -0.00170687499218407 ...
        -0.00164416183033638 -0.00158214684651925 -0.00152090452032456 ...
        -0.00146050494713648 -0.00140101384494936 -0.00134249257100879 ...
        -0.00128499814795165 -0.00122858329910381 -0.00117329649257858 ...
        -0.00111918199380472 -0.00106627992609986 -0.00101462633889412 ...
        -0.000964253283198183 -0.000915188893902272 -0.000867457478484594 ...
        -0.000821079611702721 -0.000776072235836772 -0.000732448766050416 ...
        -0.000690219200434199 -0.000649390234295436 -0.000609965378260016 ...
        -0.000571945079753823 -0.000535326847435036 -0.000500105378153382 ...
        -0.000466272686018297 -0.000433818233164985 -0.000402729061815448 ...
        -0.000372989927240567 -0.000344583431239397 -0.000317490155762638 ...
        -0.000291688796319052 -0.000267156294815999 -0.000243867971498506 ...
        -0.000221797655665102 -0.000200917814853059 -0.000181199682200634 ...
        -0.000162613381709264 -0.000145128051144483 -0.0001287119623304 ...
        -0.000113332638608957 -9.89569692517742e-05 -8.55513206290557e-05 ...
        -7.30816439568514e-05 -6.15135794607481e-05 -5.08125568108303e-05 ...
        -4.09438916994148e-05 -3.18728784495713e-05 -2.35648785587394e-05 ...
        -1.59854050978055e-05 -9.10020290173803e-06 -2.87532450326844e-06 ...
        2.72279822390494e-06 7.72728673135589e-06 1.21707527765076e-05 ...
        1.60852397088714e-05 1.95021680402537e-05 2.24522852647944e-05 ...
        2.49656198828522e-05 2.70714395715377e-05 2.87982134341252e-05 ...
        3.01735782506633e-05 3.1224308642882e-05 3.19762910579523e-05 ...
        3.24545014678198e-05 3.26829866736978e-05 3.26848490988812e-05 ...
        3.24822349473199e-05 3.2096325600377e-05 3.15473321198753e-05 ...
        3.08544927219064e-05 3.00360730829204e-05 2.91093693373276e-05 ...
        2.80907136241954e-05 2.69954820396103e-05 2.58381048508675e-05 ...
        2.4632078828826e-05 2.33899815555057e-05 2.21234875652748e-05 ...
        2.08433861797536e-05 1.95596008988149e-05 1.82812102127652e-05 ...
        1.70164697039055e-05 1.57728353091724e-05 1.45569876194048e-05 ...
        1.33748570949522e-05 1.22316500817784e-05 1.11318755169139e-05 ...
        1.0079372217008e-05 9.07733664881729e-06 8.12835108568961e-06 ...
        7.23441205943757e-06 6.39695902240155e-06 5.61690313995802e-06 ...
        4.89465613918705e-06 4.23015914485707e-06 3.62291143927567e-06 ...
        3.07199908786578e-06 2.57612337753367e-06 2.13362901996496e-06 ...
        1.74253207690144e-06 1.40054756918313e-06 1.10511673587406e-06 ...
        8.53433914099155e-07 6.42473014291437e-07 4.69013569366105e-07 ...
        3.29666339883144e-07 2.20898460529298e-07 1.3905811622373e-07 ...
        8.03987388296356e-08 4.1102717826122e-08 1.73046203575215e-08 ...
        5.1139178308147e-09 6.37217673709085e-10 0]);
end

y = step(Hd,double(x));
y = circshift(y, -250);
size(y)
y = y(1:end-250);
size(y)


% [EOF]
