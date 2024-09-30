set(figure(1), 'Position', get(0, 'ScreenSize'));
set(gcf, 'color', 'white');
plot(tout, Refer, 'k:', 'LineWidth', 7);  hold on;
plot(tout, Reali, 'Color', [0, 0, 1], 'LineWidth', 4);
set(gca, 'FontName', 'Arial', 'FontSize', 18);  grid on;  box on
xlabel('$t$ [s]', 'fontsize', 24, 'fontweight', 'n', 'color', 'k', 'Interpreter', 'latex');
ylabel('$q$ [rad]', 'fontsize', 24, 'fontweight', 'n', 'color', 'k', 'Interpreter', 'latex');
set(legend('${q}^\star$', '$q$'), 'box', 'off', 'Location', 'northeast', 'FontSize', 24, 'Interpreter', 'latex');
xlim([0 20]);  ylim([-0.65 0.9]);  print('Controlled_Position', '-dmeta');

set(figure(2), 'Position', get(0, 'ScreenSize'));
set(gcf, 'color', 'white');
plot(tout, Torque, 'Color', [0.7, 0, 0], 'LineWidth', 5);
set(gca, 'FontName', 'Arial', 'FontSize', 18);  grid on;  box on
xlabel('$t$ [s]', 'fontsize', 24, 'fontweight', 'n', 'color', 'k', 'Interpreter', 'latex');
ylabel('$\tau$ [Nm]', 'fontsize', 24, 'fontweight', 'n', 'color', 'k', 'Interpreter', 'latex');
xlim([0 20]);  ylim([-2 2.5]);  print('Input_Control', '-dmeta');

set(figure(3), 'Position', get(0, 'ScreenSize'));
set(gcf, 'color', 'white');
plot(tout, Error, 'Color', [0.2, 0.3, 0.1], 'LineWidth', 5);
set(gca, 'FontName', 'Arial', 'FontSize', 18);  grid on;  box on
xlabel('$t$ [s]', 'fontsize', 24, 'fontweight', 'n', 'color', 'k', 'Interpreter', 'latex');
ylabel('$e_{q}$ [rad]', 'fontsize', 24, 'fontweight', 'n', 'color', 'k', 'Interpreter', 'latex');
xlim([0 20]);  print('Position_Error', '-dmeta');    