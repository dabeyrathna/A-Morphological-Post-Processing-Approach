function [dice_index] = Dice_eval(I, Im)  
    dice_index = dice(im2bw(I),im2bw(im2gray(Im)));
end