tree = [10 50 100 200 300 800];
accTR = [99.5575 100.00 100.00 100.00 100.00 100.00];
accTS = [80.9609 81.3167 80.7829 81.4947 81.8505 79.8932];

clf();
hold on;
plot(tree, accTR, 'b-')
plot(tree, accTS, 'r-')
xlabel('Number of Trees')
ylabel('Accuracy')
legend('Training','Test')
hold off;