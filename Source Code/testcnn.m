

filename = 'test.xlsx';
a = xlsread(filename)
a_series=a'                                               
filename = 'train.xlsx';
b = xlsread(filename)
b_series=b'
inputs=a_series;                                 
outputs=b_series;

net=network( ...
    1,            ...                                   
    2,            ...                                   
    [1;0],        ...                                   
    [1; 0],        ...                                  
    [0 0; 1 0],  ...                                   
    [0 1]        ...                                   
    );
 %number of hidden layer(1st layer) neurons
 net.layers{1}.size=5;
 %hidden layer transfer function
 net.layers{1}.transferFcn='logsig';
 %configure network
 net=configure(net,inputs,outputs);
 view(net);
 %network training
 net.trainFcn='trainlm';                         
 net.performFcn='mse';                        
 net=train(net,inputs,outputs);% generate automatically to SIMULINK model 
 
 
 