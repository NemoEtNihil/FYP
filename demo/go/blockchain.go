package main

import (
	"fmt"
	"crypto/sha256"
	"math/rand"
	"time"
)

// initialize

func main(){
	difficulty := 3

	// initialize blockchain
	blockchain := []Block{generateOriginalBlock(difficulty)}
	
	// sample new blocks
	blockchain = append(blockchain, generateBlock(blockchain[len(blockchain)-1], "Sample Data 1", difficulty, []string{"Validator_001","Validator_002","Validator_003","Validator_042","Validator_075","Validator_101","Validator_503","Validator_260"}))
	blockchain = append(blockchain, generateBlock(blockchain[len(blockchain)-1], "Sample Data 2", difficulty, []string{"Validator_001","Validator_002","Validator_003","Validator_042"}))
	blockchain = append(blockchain, generateBlock(blockchain[len(blockchain)-1], "Sample Data 3", difficulty, []string{"Validator_001","Validator_002","Validator_003","Validator_042","Validator_075","Validator_101","Validator_503","Validator_260"}))
	blockchain = append(blockchain, generateBlock(blockchain[len(blockchain)-1], "Sample Data 4", difficulty, []string{"Validator_001","Validator_002","Validator_101","Validator_503","Validator_260"}))
	blockchain = append(blockchain, generateBlock(blockchain[len(blockchain)-1], "Sample Data 5", difficulty, []string{"Validator_003","Validator_042","Validator_075","Validator_101","Validator_503","Validator_260"}))

	// print blockchain contents
	fmt.Println("\nBlockchain Contents:\n")
	for _, block := range blockchain {
		fmt.Printf("Index: %d\n", block.Index)
		fmt.Printf("Timestamp: %s\n", block.Timestamp)
		fmt.Printf("PrevHash: %s\n", block.PreviousHash)
		fmt.Printf("Data: %s\n", block.Data)
		fmt.Printf("Nonce: %d\n", block.Nonce)
		fmt.Printf("Difficulty: %d\n", block.Difficulty)
		fmt.Printf("Hash: %s\n\n", block.Hash)
		fmt.Println("\n==================================================================================\n")
	}
}

type Block struct {
	Index int
	Timestamp string
	Data string
	PreviousHash string
	Nonce int
	Difficulty int
	Hash string
}

// calc hash using SHA256
func calculateHash(b Block) string {
	data := fmt.Sprintf("%d%s%s%s%d",b.Index, b.Timestamp, b.Data, b.PreviousHash, b.Nonce)
	hash := sha256.Sum256([]byte(data))

	return fmt.Sprintf("%x", hash)
}

func generateBlock(oldBlock Block, data string, diff int, validators []string) (Block){
	var newBlock Block
	t := time.Now()
	newBlock.Index = oldBlock.Index + 1
	newBlock.Timestamp = t.String()
	newBlock.Data = data
	newBlock.PreviousHash = oldBlock.Hash
	newBlock.Nonce = 0
	newBlock.Difficulty = diff

	rand.Seed(time.Now().UnixNano())
	valIndex := rand.Intn(len(validators))
	val := validators[valIndex]

	newBlock.Hash = calculateHash(newBlock) + val

	return newBlock
}

func generateOriginalBlock(diff int) (Block){
	var newBlock Block
	t := time.Now()
	newBlock.Index = 0
	newBlock.Timestamp = t.String()
	newBlock.Data = "Original Block"
	newBlock.Nonce = 0
	newBlock.Difficulty = diff

	newBlock.Hash = calculateHash(newBlock)

	return newBlock
}

// validate intergrity of blockchain

func isBlockValid(newBlock Block, oldBlock Block) bool {
	if (oldBlock.Index + 1) != newBlock.Index {
		return false
	}

	if oldBlock.Hash != newBlock.PreviousHash {
		return false
	}

	if calculateHash(newBlock) != newBlock.Hash {
		return false
	}

	return true
}

