//
//  MachineLearning.swift
//  Bullshit
//
//  Created by L.A. van de Guchte on 07/03/2018.
//  Copyright © 2018 L.A. van de Guchte. All rights reserved.
//

import Foundation

class MachineLearning{
    var nHiddenN: Int;
    var nHiddenLayers: Int;
    var learnRate: Double;
    var meanWeight: Double;
    var weightSpread: Double;
    var maxEpoch: Double;
    var nInputN: Int;
    var nOutputN: Int;
    var hiddenWeights: [[Double]];
    var outputWeights: [[Double]];
    var deltaOutputB: [[Double]];
    var deltaHiddenB: [[Double]];
    var deltaOutputT: [[Double]];
    var deltaHiddenT: [[Double]];
    
    var cBull: Int;
    var cTruth: Int;
    
    var input: [Int];
    var hiddenOutput: [Double];
    var output: [Double];
    
    var epoch: Int;
    var error: Double;
    var msError: [Double];
    
    init(start: Bool) {
        // Parameters ------------------------------------------------------------------------------------------
        self.nHiddenN = 10;
        self.nHiddenLayers = 1; // only 1 layer possible
        self.learnRate = 0.5;
        self.meanWeight = 0.0;
        self.weightSpread = 0.1;
        self.maxEpoch = 10;
        // -----------------------------------------------------------------------------------------------------
        
        // Inits -----------------------------------------------------------------------------------------------
        self.nInputN = 5;
        self.nHiddenN += 1;
        self.nOutputN = 1;
        self.hiddenWeights = [[Double]](repeating:[Double] (repeating:0.0, count:nHiddenN), count:nInputN)
        self.outputWeights = [[Double]](repeating:[Double] (repeating:0.0, count:nOutputN), count:nHiddenN)
        self.deltaOutputB = [[Double]](repeating:[Double] (repeating:0.0, count:nOutputN), count:nHiddenN)
        self.deltaHiddenB = [[Double]](repeating:[Double] (repeating:0.0, count:nHiddenN), count:nInputN);
        self.deltaOutputT = [[Double]](repeating:[Double] (repeating:0.0, count:nOutputN), count:nHiddenN)
        self.deltaHiddenT = [[Double]](repeating:[Double] (repeating:0.0, count:nHiddenN), count:nInputN);
        
        self.cBull = 0;
        self.cTruth = 0;
        
        self.input = [Int](repeating:0, count: nInputN-1)
        self.hiddenOutput = [Double](repeating:0.0, count:nHiddenN-1)
        self.output = [Double](repeating:0.0, count:nOutputN);
        
        self.epoch = 0;
        self.error = 0.0;
        self.msError = [Double]()
        // -----------------------------------------------------------------------------------------------------
        
        // Init weights ----------------------------------------------------------------------------------------
        if (start == true){
            let randomN = 100000.0;
            for i in 0...self.nInputN-1{
                for j in 0...self.nHiddenN-2{
                    self.hiddenWeights[i][j] = Double(arc4random_uniform(UInt32(randomN)))/(randomN/self.weightSpread);
                    self.hiddenWeights[i][j] -= self.weightSpread/2;
                    self.hiddenWeights[i][j] += self.meanWeight;
                }
            }
            
            for i in 0...self.nHiddenN-1{
                for j in 0...self.nOutputN-1{
                    self.outputWeights[i][j] = Double(arc4random_uniform(UInt32(randomN)))/(randomN/self.weightSpread);
                    self.outputWeights[i][j] -= self.weightSpread/2;
                    self.outputWeights[i][j] += self.meanWeight;
                }
            }
        }
            // -----------------------------------------------------------------------------------------------------
            // load weights ----------------------------------------------------------------------------------------
        else{
            var documentsDirectory: NSURL?
            var fileURLH: NSURL?
            var fileURLO: NSURL?
            var fileURLPEpoch: NSURL?
            documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as NSURL
            fileURLH = documentsDirectory!.appendingPathComponent("weightsH.txt")! as NSURL
            fileURLO = documentsDirectory!.appendingPathComponent("weightsO.txt")! as NSURL
            fileURLPEpoch = documentsDirectory!.appendingPathComponent("errorPEpoch.txt")! as NSURL
            // weights hidden
            var sometext: String;
            do{
                try sometext = String(contentsOfFile: (fileURLH! as URL).path)
            }
            catch{
                sometext = "";
                print("Nope")
            }
            var i = 0;
            var j = 0;
            var substr = "";
            self.hiddenWeights = [[Double]](repeating:[Double] (repeating:0.0, count:nHiddenN), count:nInputN);
            for ch in sometext{
                if (ch == ","){
                    hiddenWeights[i][j] = (substr as NSString).doubleValue;
                    substr = "";
                    j = j + 1;
                }
                else if(ch == "\n"){
                    hiddenWeights[i][j] = (substr as NSString).doubleValue;
                    substr = "";
                    i = i + 1;
                    j = 0;
                }
                else{
                    substr.append(ch);
                }
            }
            // weights Output
            do{
                try sometext = String(contentsOfFile: (fileURLO! as URL).path)
            }
            catch{
                sometext = "";
                print("Nope")
            }
            i = 0;
            j = 0;
            substr = "";
            self.outputWeights = [[Double]](repeating:[Double] (repeating:0.0, count:nOutputN), count:nHiddenN);
            for ch in sometext{
                if (ch == ","){
                    outputWeights[i][j] = (substr as NSString).doubleValue;
                    substr = "";
                    j = j + 1;
                }
                else if(ch == "\n"){
                    outputWeights[i][j] = (substr as NSString).doubleValue;
                    substr = "";
                    i = i + 1;
                    j = 0;
                }
                else{
                    substr.append(ch);
                }
            }
            // epoch error
            do{
                try sometext = String(contentsOfFile: (fileURLPEpoch! as URL).path)
            }
            catch{
                sometext = "";
                print("Nope")
            }
            j = 0;
            substr = "";
            for ch in sometext{
                if (ch == ","){
                    self.msError.append((substr as NSString).doubleValue);
                    substr = "";
                    j = j + 1;
                    
                }
                else{
                    substr.append(ch);
                }
            }
            epoch = msError.count;
        }
        // -----------------------------------------------------------------------------------------------------
    }
    
    // Functions -----------------------------------------------------------------------------------------------
    func sigmoid(value: Double) -> Double{
        let output = 1/(1+exp(-1*value));
        return output;
    }
    
    // ---------------------------------------------------------------------------------------------------------
    
    func getChance (input2: [Int]) -> Double{
        self.input = input2;
        self.input.append(1); // add bias
        
        // calculate output of hidden nodes
        for i in 0...nHiddenN-2{
            var hiddenActivation = 0.0;
            for j in 0...nInputN-1{
                hiddenActivation += hiddenWeights[j][i] * Double(self.input[j]);
            }
            self.hiddenOutput[i] = sigmoid(value: hiddenActivation);
        }
        self.hiddenOutput.append(1); // add hidden bias
        
        // calculate output
        for i in 0...nOutputN-1{
            var outputActivation = 0.0;
            for j in 0...nHiddenN-1{
                outputActivation += self.outputWeights[j][i] * Double(self.hiddenOutput[j])
            }
            self.output[i] = sigmoid(value: outputActivation);
        }
        return output[0]
    }
    
    func calcDeltas(target: Int){
        
        // compute output error
        var outputError = [Double](repeating:0.0, count:nOutputN);
        for i in 0...nOutputN-1{
            //outputError[i] = (-1 * Double(target[index]) * log2(output[i])) - ((1.0 - Double(target[index])) * log2(1-output[i]));
            outputError[i] = output[i] * (1.0 - output[i]) * (Double(target) - output[i]);
            //print(outputError[i])
        }
        // compute the hidden error
        var hiddenError = [Double](repeating:0.0, count:nHiddenN);
        for i in 0...nHiddenN-1{
            var hiddenTemp = 0.0
            for j in 0...nOutputN-1{
                hiddenTemp += output[j] * outputError[j]
            }
            hiddenError[i] = hiddenOutput[i] * (1.0 - hiddenOutput[i]) * hiddenTemp;
        }
        
        if (target == 1){
            cBull += 1;
            // update output weight matrices
            for i in 0...nOutputN-1{
                for j in 0...nHiddenN-1{
                    deltaOutputB[j][i] += learnRate * outputError[i] * hiddenOutput[j];
                    //outputWeights[j][i] = outputWeights[j][i] + deltaOutput[j][i];
                }
            }
            
            // update hidden weight matrices
            for i in 0...nInputN-1{
                for j in 0...nHiddenN-1{
                    deltaHiddenB[i][j] += learnRate * hiddenError[j] * Double(input[i]);
                    //hiddenWeights[i][j] = hiddenWeights[i][j] + deltaHidden[i][j];
                }
            }
        }
        else{
            cTruth += 1;
            // update output weight matrices
            for i in 0...nOutputN-1{
                for j in 0...nHiddenN-1{
                    deltaOutputT[j][i] += learnRate * outputError[i] * hiddenOutput[j];
                    //outputWeights[j][i] = outputWeights[j][i] + deltaOutput[j][i];
                }
            }
            
            // update hidden weight matrices
            for i in 0...nInputN-1{
                for j in 0...nHiddenN-1{
                    deltaHiddenT[i][j] += learnRate * hiddenError[j] * Double(input[i]);
                    //hiddenWeights[i][j] = hiddenWeights[i][j] + deltaHidden[i][j];
                }
            }
        }
        
        // calculate mean square error of round
        error += pow(outputError[0],2.0);
    }
    
    func saveWeights(){
        // make sure that outputs of bullshit and truth are normalized
        let pTruth = Double(cBull)/Double(cBull+cTruth);
        let pBull = Double(cTruth)/Double(cBull+cTruth);
        for i in 0...nOutputN-1{
            for j in 0...nHiddenN-1{
                outputWeights[j][i] = outputWeights[j][i] + pTruth * deltaOutputT[j][i];
                outputWeights[j][i] = outputWeights[j][i] + pBull * deltaOutputB[j][i];
            }
        }
        // save weights after end of game (one game = one epoch)
        epoch += 1;
        print("Epoch:");
        print(epoch)
        msError.append(error);
        // save weight hidden
        var documentsDirectory: NSURL?
        var fileURLH: NSURL?
        var fileURLO: NSURL?
        var fileURLPEpoch: NSURL?
        documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as NSURL
        fileURLH = documentsDirectory!.appendingPathComponent("weightsH.txt")! as NSURL
        fileURLO = documentsDirectory!.appendingPathComponent("weightsO.txt")! as NSURL
        fileURLPEpoch = documentsDirectory!.appendingPathComponent("errorPEpoch.txt")! as NSURL
        var something = "";
        for i in 0...nInputN-1{
            for j in 0...nHiddenN-1{
                something.append(hiddenWeights[i][j].description)
                something.append(",")
            }
            something = String(something.dropLast(1))
            something.append("\n")
        }
        do{
            try something.write(to:fileURLH! as URL, atomically: false, encoding:.utf8);
        }catch{
            print("Nope");
        }
        // save weights output
        something = "";
        for i in 0...nHiddenN-1{
            for j in 0...nOutputN-1{
                something.append(outputWeights[i][j].description)
                something.append(",")
            }
            something = String(something.dropLast(1))
            something.append("\n")
        }
        do{
            try something.write(to:fileURLO! as URL, atomically: false, encoding:.utf8);
        }catch{
            print("Nope");
        }
        // save ms error per epoch
        something = "";
        for i in 0...msError.count-1{
            something.append(msError[i].description)
            something.append(",")
        }
        do{
            try something.write(to:fileURLPEpoch! as URL, atomically: false, encoding:.utf8);
        }catch{
            print("Nope");
        }
    }
    
}


