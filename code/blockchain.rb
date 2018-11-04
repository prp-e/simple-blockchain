require 'date'
require 'digest'
require 'json'

class Blockchain 
 
    attr_reader :chain, :current_transactions, :default_block, :last_block 

 def initialize()
  @chain = [] 
  @current_transactions = [] 
  @default_block = new_block(100, 1)
  @last_block = @chain[-1] 
 end 

 def new_transaction(sender, recipient, amount)
  #amount is used here for banking issues, but you can modifiy it. 
  
  @current_transactions << {
          'sender' => sender ,
          'recipient' => recipient, 
          'amount' => amount
      }
  

  return @last_block['index'] + 1 

 end

 def new_block(proof, previous_hash=nil)

    block = {

        'index' => @chain.length + 1 ,
        'timestamp' => Time.now().to_i ,
        'transactions' => @current_transactions ,
        'proof' => proof ,
        'hash' => previous_hash

    }

    @current_transactions = [] 
    @chain << block 

    return block 

 end 

 def hash(block)
    block_string = block.to_json 
    return Digest::SHA1.hexdigest(block_string)
 end 

 def valid_proof(proof, last_proof)
    guess = "#{proof}#{last_proof}"
    hash_guess = Digest::SHA1.hexdigest(guess)
    #puts hash_guess
    return hash_guess.reverse[0, 9].include?"0000"
 end 

 def proof_of_work(last_proof)
    proof = 0
    while valid_proof(proof, last_proof) == false 
        proof += 1
    #   puts proof 
    end 

    return proof 

 end 

 def mine(recipient) 

    last_block = @last_block 
    last_proof = @last_block['proof'] 
    proof = proof_of_work(last_proof) 
    new_transaction('0', recipient, 1)
    previous_hash = hash(last_block)
    block = new_block(proof, previous_hash)
    @last_block = @chain[-1]
    response = {'index' => block['index'], 'transactions' => block['transactions'], 'proof' => block['proof'], 'previous_hash' => block['previous_hash']}

    return response
 end

end