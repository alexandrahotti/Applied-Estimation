
% load('visiondata.mat');
target_data = importdata('visiondata.mat');
% fixed_meas_1 = target_data.fixed_meas_1;
% fixed_true = target_data.fixed_true;
% % visualize_vision_data(fixed_meas_1_data,fixed_true);
% pf_track(fixed_meas_1, fixed_true, 2);

meas_1 = target_data.fixed_meas_1;
true_motion = target_data.fixed_true;
% visualize_vision_data(fixed_meas_1_data,fixed_true);
pf_track(meas_1, true_motion, 2);