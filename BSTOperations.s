
.text

	# FUNCTION: void bst_init_node(BSTNode *node, int key)
	# This function takes a pointer to a BSTNode and initializes it,
	# setting its children to NULL and its value to the accepted key.
	# 
	# Corresponding C Code:
	# void bst_init_node(BSTNode *node, int key)
	# {
	# 	node->key = key;
	# 	node->left = NULL;
	# 	node->right = NULL;
	# }
	# 
	# RESGISTERS:
	#	a0:	accepted pointer to a BST node
	# 	a1:	accepted key value
	
.globl	bst_init_node
bst_init_node:
	addiu	$sp, $sp,-24			# allocate stack space
	sw	$fp, 0($sp)			# old fp - store
	sw	$ra, 4($sp)			# old ra - store
	addiu	$fp, $sp,20			# set new frame pointer
	
	
	sw	$a1, 0($a0)			# node->key = key
	sw	$zero, 4($a0)			# node->left = NULL
	sw	$zero, 8($a0)			# node-> right = NULL
	
	
	lw	$ra, 4($sp)			# old ra - restore
	lw	$fp, 0($sp)			# old fp - restore
	addiu	$sp, $sp,24			# deallocate stack space
	jr	$ra				# return
	
	
	
	
	# FUNCTION: BSTNode *bst_search(BSTNode *node, int key)
	# This function performs a BST search, returning a pointer to the
	# correct node if found, and NULL if not.
	# 
	# Corresponding C Code:
	# BSTNode *bst_search(BSTNode *node, int key)
	# {
	# 	BSTNode *cur = node;
	# 	while (cur != NULL)
	# 	{
	# 		if (cur->key == key)
	# 			return cur;
	# 
	# 		if (key < cur->key)
	# 			cur = cur->left;
	# 		else
	# 			cur = cur->right;
	# 	}
	# 	return NULL;
	# }
	# 
	# REGISTERS:
	# 	a0: accepted node pointer / cur node
	# 	a1: accepted key value
	# 	t1: node->key
	# 	t2: various temporaries
	
.globl	bst_search
bst_search:
	addiu	$sp, $sp,-24			# allocate stack space
	sw	$fp, 0($sp)			# old fp - store
	sw	$ra, 4($sp)			# old ra - store
	addiu	$fp, $sp,20			# set new frame pointer
	
	
bst_search_LOOP:
	beq	$a0,$zero, bst_search_LOOP_DONE	# if (cur == NULL) break loop
	
	lw	$t1, 0($a0)			# t1 = node->key
	
	bne	$t1,$a1, bst_search_NOT_FOUND	# branch away if value not yet found
	
	# Value has been found here, so return node:
	add	$v0, $zero,$a0			# returnVal = cur
	j	bst_search_EPILOGUE		# breanch to epilogue
	
	
bst_search_NOT_FOUND:
	# Not yet found, so determine if less than or greater than:
	slt	$t2, $a1,$t1			# t2 = key < node->key
	beq	$t2,$zero, bst_search_GREATER	# if !(key < node->key) go to else
	
	# SearchKey < cur key, so search left subtree:
	lw	$a0, 4($a0)			# cur = cur->left
	
	j	bst_search_LOOP

bst_search_GREATER:
	# SearchKey > cur key, so search right subtree:
	lw	$a0, 8($a0)			# cur = cur->left
	
	j	bst_search_LOOP
	
	
bst_search_LOOP_DONE:
	add	$v0, $zero,$zero		# returnVal = NULL
	
	
bst_search_EPILOGUE:
	lw	$ra, 4($sp)			# old ra - restore
	lw	$fp, 0($sp)			# old fp - restore
	addiu	$sp, $sp,24			# deallocate stack space
	jr	$ra				# return
	
	
	
	
	# FUNCTION: int bst_count(BSTNode *node)
	# This function returns the number of nodes in an accepted BST.
	# 
	# Corresponding C Code:
	# int bst_count(BSTNode *node)
	# {
	# 	if (node == NULL)
	# 		return 0;
	# 	return bst_count(node->left) + 1 + bst_count(node->right);
	# }
	# 
	# REGISTERS:
	# 	t1: various temporaries
	# 	s0: value to return
	# 	s3: *node pointer
	
.globl	bst_count
bst_count:
	addiu	$sp, $sp,-24			# allocate stack space
	sw	$fp, 0($sp)			# old fp - store
	sw	$ra, 4($sp)			# old ra - store
	addiu	$fp, $sp,20			# set new frame pointer
	
	addiu	$sp, $sp,-4			# old s0 - allocate space
	sw	$s0, 0($sp)			# old s0 - store
	addiu	$sp, $sp,-4			# old s3 - allocate space
	sw	$s3, 0($sp)			# old s3 - store
	
	
	add	$s3, $zero,$a0			# s3 = node
	
	bne	$s3,$zero, bst_count_NOT_NULL	# if (node != NULL) branch away
	
	# Node is null here, so return 0:
	add	$v0, $zero,$zero		# returnVal = 0
	j	bst_count_EPILOGUE
	
bst_count_NOT_NULL:
	# Node not null, so recurse:
	lw	$a0, 4($s3)			# a0 = node->left
	jal	bst_count			# call bst_count(node->left)
	add	$s0, $zero,$v0			# curReturnVal = bst_count(node->left)
	
	addi	$s0, $s0,1			# curReturnVal++ (for current node)
	
	lw	$a0, 8($s3)			# a0 = node->right
	jal	bst_count			# call bst_count(node->right)
	add	$s0, $s0,$v0			# curReturnVal += bst_count(node->right)
	
	add	$v0, $zero,$s0			# returnVal = curReturnVal
	
	
bst_count_EPILOGUE:
	lw	$s3, 0($sp)			# old s3 - restore
	addiu	$sp, $sp,4			# old s3 - deallocate space
	lw	$s0, 0($sp)			# old s0 - restore
	addiu	$sp, $sp,4			# old s0 - deallocate space

	lw	$ra, 4($sp)			# old ra - restore
	lw	$fp, 0($sp)			# old fp - restore
	addiu	$sp, $sp,24			# deallocate stack space
	jr	$ra				# return
	
	
	
	
	# FUNCTION: void bst_in_order_traversal(BSTNode *node)
	# This function prints every node in an accepted BST, inorder, one per line.
	# 
	# Corresponding C Code:
	# void bst_in_order_traversal(BSTNode *node)
	# {
	# 	if (node == NULL)
	# 		return;
	# 
	# 	bst_in_order_traversal(node->left);
	# 	printf("%d\n", node->key);
	# 	bst_in_order_traversal(node->right);
	# }
	# 
	# REGISTERS:
	# 	s0: cur node
	
.globl	bst_in_order_traversal
bst_in_order_traversal:
	addiu	$sp, $sp,-24			# allocate stack space
	sw	$fp, 0($sp)			# old fp - store
	sw	$ra, 4($sp)			# old ra - store
	addiu	$fp, $sp,20			# set new frame pointer
	
	addiu	$sp, $sp,-4			# old s0 - allocate space
	sw	$s0, 0($sp)			# old s0 - store
	
	
	add	$s0, $zero,$a0			# s0 = node
	
	bne	$s0,$zero, bst_in_order_traversal_NOT_LEAF	# if (node != NULL) branch away
	
	# Node is null here, so return:
	j	bst_in_order_traversal_EPILOGUE
	

bst_in_order_traversal_NOT_LEAF:
	# Print inorder: left subtree, local node, right subtree:
	lw	$a0, 4($s0)			# a0 = node->left
	jal	bst_in_order_traversal		# call bst_in_order_traversal(node->left)
	
	addi	$v0, $zero,1			# print(node->key)
	lw	$a0, 0($s0)
	syscall
	
	addi	$v0, $zero,11			# print('\n')
	addi	$a0, $zero,10
	syscall
	
	lw	$a0, 8($s0)			# a0 = node->right
	jal	bst_in_order_traversal		# call bst_in_order_traversal(node->right)
	
	
bst_in_order_traversal_EPILOGUE:
	lw	$s0, 0($sp)			# old s0 - restore
	addiu	$sp, $sp,4			# old s0 - deallocate space

	lw	$ra, 4($sp)			# old ra - restore
	lw	$fp, 0($sp)			# old fp - restore
	addiu	$sp, $sp,24			# deallocate stack space
	jr	$ra				# return
	
	
	
	
	# FUNCTION: void bst_pre_order_traversal(BSTNode *node)
	# This function prints every node in an accepted BST, preorder, one per line.
	# 
	# Corresponding C Code:
	# void bst_pre_order_traversal(BSTNode *node)
	# {
	# 	if (node == NULL)
	# 		return;
	# 
	# 	printf("%d\n", node->key);
	# 	bst_in_order_traversal(node->left);
	# 	bst_in_order_traversal(node->right);
	# }
	# 
	# REGISTERS:
	# 	s0: cur node
	
.globl	bst_pre_order_traversal
bst_pre_order_traversal:
	addiu	$sp, $sp,-24			# allocate stack space
	sw	$fp, 0($sp)			# old fp - store
	sw	$ra, 4($sp)			# old ra - store
	addiu	$fp, $sp,20			# set new frame pointer
	
	addiu	$sp, $sp,-4			# old s0 - allocate space
	sw	$s0, 0($sp)			# old s0 - store
	
	
	add	$s0, $zero,$a0			# s0 = node
	
	bne	$s0,$zero, bst_pre_order_traversal_NOT_LEAF	# if (node != NULL) branch away
	
	# Node is null here, so return:
	j	bst_pre_order_traversal_EPILOGUE
	

bst_pre_order_traversal_NOT_LEAF:
	# Print preorder: local node, left subtree, right subtree:
	addi	$v0, $zero,1			# print(node->key)
	lw	$a0, 0($s0)
	syscall
	
	addi	$v0, $zero,11			# print('\n')
	addi	$a0, $zero,10
	syscall
	
	lw	$a0, 4($s0)			# a0 = node->left
	jal	bst_pre_order_traversal		# call bst_pre_order_traversal(node->left)
	
	lw	$a0, 8($s0)			# a0 = node->right
	jal	bst_pre_order_traversal		# call bst_pre_order_traversal(node->right)
	
	
bst_pre_order_traversal_EPILOGUE:
	lw	$s0, 0($sp)			# old s0 - restore
	addiu	$sp, $sp,4			# old s0 - deallocate space

	lw	$ra, 4($sp)			# old ra - restore
	lw	$fp, 0($sp)			# old fp - restore
	addiu	$sp, $sp,24			# deallocate stack space
	jr	$ra				# return
	
	
	
	
	# FUNCTION: BSTNode *bst_insert(BSTNode *root, BSTNode *newNode)
	# This function accepts a BST and a new node, inserts the node into the BST,
	# and returns the updated BST.
	# 
	# Corresponding C Code:
	# BSTNode *bst_insert(BSTNode *root, BSTNode *newNode)
	# {
	# 	if (root == NULL)
	# 		return newNode;
	# 
	# 	if (newNode->key < root->key)
	# 		root->left = bst_insert(root->left, newNode);
	# 	else
	# 		root->right = bst_insert(root->right, newNode);
	# 
	# 	return root;
	# }
	# 
	# REGISTERS:
	# 	s0: *root
	# 	s1: *newNode
	# 	t0: root->key
	# 	t1: newNode->key
	# 	t5: various temporaries
	# 	TODO
	
.globl	bst_insert
bst_insert:
	addiu	$sp, $sp,-24			# allocate stack space
	sw	$fp, 0($sp)			# old fp - store
	sw	$ra, 4($sp)			# old ra - store
	addiu	$fp, $sp,20			# set new frame pointer
	
	addiu	$sp, $sp,-4			# old s0 - allocate space
	sw	$s0, 0($sp)			# old s0 - store
	addiu	$sp, $sp,-4			# old s1 - allocate space
	sw	$s1, 0($sp)			# old s1 - store
	
	
	add	$s0, $zero,$a0			# s0 = root
	add	$s1, $zero,$a1			# s1 = newNode
	
	bne	$s0,$zero, bst_insert_NOT_NULL	# if (root != null) branch away
	
	# Root is null here, so return newNode:
	add	$v0, $zero,$s1			# returnVal = newNode
	j	bst_insert_EPILOGUE


bst_insert_NOT_NULL:
	lw	$t0, 0($s0)			# t0 = root->key
	lw	$t1, 0($s1)			# t1 = newNode->key
	
	slt	$t5, $t1,$t0			# t5 = (newNode->key < root->key)
	beq	$t5,$zero, bst_insert_NEW_NODE_GREATER	# if (newNode->key >= root->key) enter else
	
	lw	$a0, 4($s0)			# a0 = root->left
	add	$a1, $zero,$s1			# a1 = newNode
	
	jal	bst_insert			# call bst_insert(root->left, newNode)
	
	sw	$v0, 4($s0)			# root->left = bst_insert(root->left, newNode)
	
	j	bst_insert_SET_RETURN		# jump past else clause
	
	
bst_insert_NEW_NODE_GREATER:
	lw	$a0, 8($s0)			# a0 = root->right
	add	$a1, $zero,$s1			# a1 = newNode
	
	jal	bst_insert			# call bst_insert(root->right, newNode)
	
	sw	$v0, 8($s0)			# root->right = bst_insert(root->right, newNode)


bst_insert_SET_RETURN:
	add	$v0, $zero,$s0			# returnVal = root

bst_insert_EPILOGUE:
	lw	$s1, 0($sp)			# old s1 - restore
	addiu	$sp, $sp,4			# old s1 - deallocate space
	lw	$s0, 0($sp)			# old s0 - restore
	addiu	$sp, $sp,4			# old s0 - deallocate space

	lw	$ra, 4($sp)			# old ra - restore
	lw	$fp, 0($sp)			# old fp - restore
	addiu	$sp, $sp,24			# deallocate stack space
	jr	$ra				# return
