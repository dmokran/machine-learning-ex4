function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network

%input_layer_size = 400
%hidden_layer_size = 25
%num_labels = 10

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
% =========================================================================
% Theta1 25x401
% Theta2 10x26
X = [ones(m, 1), X]'; %401x5000
ym = ([1:num_labels] == y)'; %10x5000
oneDivM = 1 / m;
lDiv2m = lambda / (2 * m);
D1 = zeros(size(Theta1)); %25x401
D2 = zeros(size(Theta2)); %10x26

%Feedforward
z2 = Theta1 * X; %25x401 * 401x5000 = 25x5000
a2NB = sigmoid(z2); %25x5000
a2 = [ones(1, m); a2NB]; %26x5000
z3 = Theta2 * a2; %10x26 * 26x5000 = 10x5000
a3 = sigmoid(z3); %10x5000
cost = (-ym .* log(a3)) - ((1-ym) .* log(1-a3)); %10x5000
regSumTh1 = sum(sum(Theta1(:,2:end).^2));
regSumTh2 = sum(sum(Theta2(:,2:end).^2));
regTerm = regSumTh1 + regSumTh2;
J = oneDivM * sum(sum(cost)) + lDiv2m * regTerm; %1x1

%Backpropagation
d3 = a3 - ym; %10x5000
d2 = (Theta2' * d3)(2:end ,:) .* sigmoidGradient(z2); %25x10 * 10x5000 .* 25x5000 = 25x5000
D2 = D2 + d3 * a2'; %10x26 + 10x5000 * 5000x26
D1 = D1 + d2 * X'; %25x401 + 25x5000 * 5000x401
regTermD2 = lambda * Theta2(:, 2:end);
regTermD1 = lambda * Theta1(:, 2:end);
D2 = [D2(:, 1), D2(:, 2:end) + regTermD2];
D1 = [D1(:, 1), D1(:, 2:end) + regTermD1];
Theta2_grad = oneDivM * D2; %10x26
Theta1_grad = oneDivM * D1; %25x401

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
