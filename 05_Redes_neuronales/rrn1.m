clear
close

nsamp = 100000;

a = -1;
b = 1;

rx = a + (b-a).*rand(nsamp,1);
ry = -0.5*rx.^3 + 1*cos(rx*5) + exp(rx) - 2 + 0.2*(abs(rx)+1).*randn(nsamp,1);

x2 = -1:0.05:1;
y2 = -0.5*x2.^3 + 1*cos(x2*5) + exp(x2) - 2;

figure
hold on
plot(rx,ry,'x');
plot(x2,y2,'linewidth',2)

%%
% close all

netconf = 10;
net = feedforwardnet(netconf);
net = train(net,rx.',ry.');

y2pred = net(x2);

figure
hold on

plot(rx,ry,'x')
plot(x2,y2pred,'linewidth',2)


