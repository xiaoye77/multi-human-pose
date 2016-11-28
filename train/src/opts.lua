projectDir = --[[projectDir or ]]paths.concat(os.getenv('HOME'),'git/multi-human-pose/train')

local M = { }

function M.parse(arg)
    local cmd = torch.CmdLine()
    cmd:text()
    cmd:text(' ---------- General options ------------------------------------')
    cmd:text()
    cmd:option('-expID',       'default', 'Experiment ID')
    cmd:option('-dataset',        'mpii', 'Dataset choice: mpii | flic')
    cmd:option('-dataDir',  projectDir .. '/data', 'Data directory')
    cmd:option('-expDir',   projectDir .. '/exp',  'Experiments directory')
    cmd:option('-manualSeed',         -1, 'Manually set RNG seed')
    cmd:option('-GPU',                 4, 'Default preferred GPU, if set to -1: no GPU')
    cmd:option('-finalPredictions',    0, 'Generate a final set of predictions at the end of training (default no, set to 1 for yes)')
    cmd:text()
    cmd:text(' ---------- Model options --------------------------------------')
    cmd:text()
    cmd:option('-netType',  'hg-stacked', 'Options: hg | hg-stacked')
    cmd:option('-addParallelSPPE',  true, '')
    cmd:option('-addSTN',  true, 'add a STN to a trained model, Options: true | false')
    cmd:option('-loadModel',      'patch+distri.t7', 'Provide full path to a previously trained model')
    cmd:option('-continue',        false, 'Pick up where an experiment left off')
    cmd:option('-branch',         'none', 'Provide a parent expID to branch off')
    cmd:option('-snapshot',            1, 'How often to take a snapshot of the model (0 = never)')
    cmd:option('-task',       'pose-int', 'Network task: pose | pose-int')
    cmd:text()
    cmd:text(' ---------- Hyperparameter options -----------------------------')
    cmd:text()
    cmd:option('-LR',             0.5e-4, 'Learning rate')
    cmd:option('-LRdecay',           0.0, 'Learning rate decay')
    cmd:option('-momentum',          0.0, 'Momentum')
    cmd:option('-weightDecay',       0.0, 'Weight decay')
    cmd:option('-crit',            'MSE', 'Criterion type')
    cmd:option('-optMethod',   'rmsprop', 'Optimization method: rmsprop | sgd | nag | adadelta')
    cmd:option('-threshold',        .001, 'Threshold (on validation accuracy growth) to cut off training early')
    cmd:text()
    cmd:text(' ---------- Training options -----------------------------------')
    cmd:text()
    cmd:option('-nEpochs',          20, 'Total number of epochs to run')
    cmd:option('-trainIters',       4000, 'Number of train iterations per epoch')
    cmd:option('-trainBatch',        4, 'Mini-batch size')
    cmd:option('-validIters',       1000, 'Number of validation iterations per epoch')
    cmd:option('-validBatch',          3, 'Mini-batch size for validation')--If you use 1, there will be a bug
    cmd:text()
    cmd:text(' ---------- Data options ---------------------------------------')
    cmd:text()
    cmd:option('-inputRes',          256, 'Input image resolution')
    cmd:option('-outputRes',          64, 'Output heatmap resolution')
    cmd:option('-trainFile',          '', 'Name of training data file')
    cmd:option('-validFile',          '', 'Name of validation file')

    local opt = cmd:parse(arg or {})
    opt.expDir = paths.concat(opt.expDir, opt.dataset)
    opt.dataDir = paths.concat(opt.dataDir, opt.dataset)
    opt.save = paths.concat(opt.expDir, opt.expID)
    return opt
end

return M
