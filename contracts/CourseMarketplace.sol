// endereço do contrato na mainNet
// 0x88b022494E00c36A12F3A0cBc69F9a1855c0cDA2
// endereço abaixo contrato NFT na mainnet
// 0xE04Ba656843887e617f45970aA14BBcB9fC40668
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// só confirmar se eu sou o dono do nft

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IERC165 { 
/**
* @dev Returns true if this contract implements the interface defined by
* `interfaceId`. See the corresponding
* https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
* to learn more about how these ids are created.
*
* This function call must use less than 30 000 gas.
*/
function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface INFT is IERC165 {
/**
* @dev Emitted when `tokenId` token is transferred from `from` to `to`.
*/
event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

/**
* @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
*/
event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

/**
* @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
*/
event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

/**
* @dev Returns the number of tokens in ``owner``'s account.
*/
function balanceOf(address owner) external view returns (uint256 balance);

/**
* @dev Returns the owner of the `tokenId` token.
*
* Requirements:
*
* - `tokenId` must exist.
*/
function ownerOf(uint256 tokenId) external view returns (address owner);

/**
* @dev Safely transfers `tokenId` token from `from` to `to`.
*
* Requirements:
*
* - `from` cannot be the zero address.
* - `to` cannot be the zero address.
* - `tokenId` token must exist and be owned by `from`.
* - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
* - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
*
* Emits a {Transfer} event.
*/
function safeTransferFrom(
address from,
address to,
uint256 tokenId,
bytes calldata data
) external;

/**
* @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
* are aware of the ERC721 protocol to prevent tokens from being forever locked.
*
* Requirements:
*
* - `from` cannot be the zero address.
* - `to` cannot be the zero address.
* - `tokenId` token must exist and be owned by `from`.
* - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
* - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
*
* Emits a {Transfer} event.
*/
function safeTransferFrom(address from,address to,uint256 tokenId) external;

/**
* @dev Transfers `tokenId` token from `from` to `to`.
*
* WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
* or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
* understand this adds an external call which potentially creates a reentrancy vulnerability.
*
* Requirements:
*
* - `from` cannot be the zero address.
* - `to` cannot be the zero address.
* - `tokenId` token must be owned by `from`.
* - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
*
* Emits a {Transfer} event.
*/
function transferFrom(address from,address to,uint256 tokenId) external;

/**
* @dev Gives permission to `to` to transfer `tokenId` token to another account.
* The approval is cleared when the token is transferred.
*
* Only a single account can be approved at a time, so approving the zero address clears previous approvals.
*
* Requirements:
*
* - The caller must own the token or be an approved operator.
* - `tokenId` must exist.
*
* Emits an {Approval} event.
*/
function approve(address to, uint256 tokenId) external;

/**
* @dev Approve or remove `operator` as an operator for the caller.
* Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
*
* Requirements:
*
* - The `operator` cannot be the caller.
*
* Emits an {ApprovalForAll} event.
*/
function setApprovalForAll(address operator, bool _approved) external;

/**
* @dev Returns the account approved for `tokenId` token.
*
* Requirements:
*
* - `tokenId` must exist.
*/
function getApproved(uint256 tokenId) external view returns (address operator);

/**
* @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
*
* See {setApprovalForAll}
*/
function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// ends nft interface


contract CourseMarketplace is ERC20  {

enum State {
Purchased,
Activated,
Deactivated
}

struct Course {
// will be in json format
// será passado com base no getAllCourses do front
uint id; // 32
uint price; // 32
// will be provided by the user
bytes32 proof; // 32
address owner; // 20
State state; // 1
}

bool public isStopped = false;

// mapping of courseHash to Course data
/**
Aqui recebe o courseHash, ou seja ident do curso e endereço do comprador
e devolve os dados do curso, ou seja:
ident do curso
preço= price,
proof = secret passado pelo comprador
endereço comprador= owner 
estado da compra
*/

// recebe o courseHash e devolve todas as informações sobre o curso relacionado
/* se eu quiser apenas uma informação específica sobre o curso basta
fazer ownedCourses[passaocoursehas].id, por exemplo.
*/ 
mapping(bytes32 => Course) private ownedCourses;

// mapping of id da compra com um courseHash 
mapping(uint => bytes32) private ownedCourseHash;

// number of all courses + id of the course
uint private totalOwnedCourses;

address payable private owner;


address public nftAddress;
// uint256 public supplyPerNFT;
INFT public inft;

/*
Iniciamente toda vez que houver o purchaseCourse nós mintamos um token para o usuário.
No deploy do contrato é definido o nome do Token e o símbolo
*/

constructor() ERC20("Web3Consulting", "FBB") {

setContractOwner(msg.sender);

}

/// Course has invalid state!
error InvalidState();

/// Course is not created!
error CourseIsNotCreated();

/// Course has already a Owner!
error CourseHasOwner();

/// Sender is not course owner!
error SenderIsNotCourseOwner();

/// Only owner has an access!
error OnlyOwner();

modifier onlyOwner() {
if (msg.sender != getContractOwner()) {
revert OnlyOwner();
}
_;
}

modifier onlyWhenNotStopped {
require(!isStopped);
_;
}

modifier onlyWhenStopped {
require(isStopped);
_;
}

receive() external payable {}

// Esta função é responsável por transferir o NFT para este contrato
function convertToTokens(uint256 _tokenId, address _nftAddress) public {

nftAddress = _nftAddress;

inft = INFT(nftAddress);

// antes o dono do NFT tem que aprovar este contrato

inft.transferFrom(msg.sender, address(this), _tokenId);

// importante atentar aqui que será mintada uma quantidade de tokens a partir da transferência do nft para este contrato

}

function withdraw(uint amount)external onlyOwner{
(bool success, ) = owner.call{value: amount}("");
require(success, "Transfer failed.");
}

function emergencyWithdraw() external onlyWhenStopped onlyOwner
{
(bool success, ) = owner.call{value: address(this).balance}("");
require(success, "Transfer failed.");
}

function selfDestruct() external onlyWhenStopped onlyOwner
{
selfdestruct(owner);
}

function stopContract() external onlyOwner { 
  isStopped = true;
}

function resumeContract()
external
onlyOwner
{
isStopped = false;
}
// proof pode ser o email, mas o ideal é que seja um secret provido pelo usuário
// aqui eu preciso transferir a fração do token para a carteira de quem está comprando
function purchaseCourse(
bytes16 courseId, // 0x00000000000000000000000000003130
bytes32 proof // 0x0000000000000000000000000000313000000000000000000000000000003130
)
external
payable
onlyWhenNotStopped
{
/* Embora para comprar o curso seja informado courseId mais secret
o courseHash é formado pelo courseId e pelo endereço do comprador
*/

/* o courseId é a identificação natural do curso, que pode ser
atribuída offChain pelo empreendedor,

podendo ser o id de um nft 

Aí o courseHash vai ser formado por esta informação invariável
e pelo msg.sender variável.

Eu vou ter outra informação chamada de id(idDacompra) que se refere 
a ordem de compra do bem. 

Por meio desse id eu consigo saber
informações sobre uma compra específica e o total de compras realizadas.

Eu vou ter um mapping(ownedCourseHash[id]=courseHash) que vai associar uma compra específica 
com um courseHash, 

e outro mapping(ownedCourses[courseHash]) que vai
associar um courseHash com informações sobre o curso.


Desse modo, sabendo o id da compra eu tenho o courseHash que é formado
pelo courseId, informação fixa que pode ser o id de um NFT e o endereço do 
comprador, msg.sender, 

e por meio desse courseHash consigo ter todas as
informações sobre aquele curso específico. 
*/

bytes32 courseHash = keccak256(abi.encodePacked(courseId, msg.sender));

// Dois endereços diversos devem gerar dois courseHash diversos
if (hasCourseOwnership(courseHash)) {
revert CourseHasOwner();
}

uint id = totalOwnedCourses++;

/* a terceira, quarta, etc. venda vai estar associada ao hash composto 
pelo id do curso e o endereço do comprador.
Ou seja, eu tenho como provar que comprei o primeiro curso.
*/

// aqui eu consigo saber qual endereço comprou o 1º, 2º etc., curso
// aqui eu consigo associar um courseHash com uma compra específica.
// o id identifica qual foi essa compra, se a primeira, a segunda, etc.
// cada compra está associada com um único courseHash
ownedCourseHash[id] = courseHash;

// faz o mapping entre o corseHash e o curso
// Dado o courseHash eu tenho todas as informações sobre o curso.
/* Para eu saber se um endereço específico comprou o curso
basta pegar esse endereço, concatenar com o courseId e gerar
o courseHash: keccak256(abi.encodePacked()

 */
ownedCourses[courseHash] = Course({
// é o IDDACOMPRA
id: id,
price: msg.value,
proof: proof,
owner: msg.sender,
state: State.Purchased
});

_mint(msg.sender, msg.value);

}

function repurchaseCourse(bytes32 courseHash)
external
payable
onlyWhenNotStopped
{
if (!isCourseCreated(courseHash)) {
revert CourseIsNotCreated();
}

if (!hasCourseOwnership(courseHash)) {
revert SenderIsNotCourseOwner();
}

Course storage course = ownedCourses[courseHash];

if (course.state != State.Deactivated) {
revert InvalidState();
}

course.state = State.Purchased;
course.price = msg.value;
}

// a ideia é mudar o state para activate
function activateCourse(bytes32 courseHash)
external
onlyWhenNotStopped
onlyOwner
{
if (!isCourseCreated(courseHash)) {
revert CourseIsNotCreated();
}

Course storage course = ownedCourses[courseHash];

if (course.state != State.Purchased) {
revert InvalidState();
}

course.state = State.Activated;
}

function deactivateCourse(bytes32 courseHash)
external
onlyWhenNotStopped
onlyOwner
{
if (!isCourseCreated(courseHash)) {
revert CourseIsNotCreated();
}

Course storage course = ownedCourses[courseHash];

if (course.state != State.Purchased) {
revert InvalidState();
}

(bool success, ) = course.owner.call{value: course.price}("");
require(success, "Transfer failed!");

course.state = State.Deactivated;
course.price = 0;
}

// transfere a propriedade deste contrato
function transferOwnership(address newOwner)
external
onlyOwner
{
setContractOwner(newOwner);
}

// aqui passa o total de cursos vendidos
function getCourseCount() external view returns (uint)
{
return totalOwnedCourses;
}

// recebe o id da compra, a ordem e devolve o courseHash correspondente 
/* Aí basta eu reconstruir o courseHash com o id da compra 
e o endereço do usuário e comparar com o courseHash obtido
pela função abaixo
 */
function getCourseHashAtIndex(uint index)
external
view
returns (bytes32)
{
return ownedCourseHash[index]; 
}

/* devolve as informações sobre o curso, com base no courseHash
id da compra
preço,
proof = secret passado pelo comprador
endereço comprador 
estado da compra 
*/
function getCourseByHash(bytes32 courseHash)
external
view
returns (Course memory)
{
return ownedCourses[courseHash];
}

// dono deste contrato
function getContractOwner()
public
view
returns (address)
{
return owner;
}

// atribui novo dono para este contrato
function setContractOwner(address newOwner) private {
owner = payable(newOwner);
}

/* Recebe o courseHash e verifica se
ownedCourses[courseHash].owner é diferente de zero
*/
function isCourseCreated(bytes32 courseHash)
private
view
returns (bool)
{
return ownedCourses[courseHash].owner != 0x0000000000000000000000000000000000000000;
}

// verifica se o msg.sender é proprietário do curso
function hasCourseOwnership(bytes32 courseHash)
private
view
returns (bool)
{
return ownedCourses[courseHash].owner == msg.sender;
}
}

/* Basicamente tendo o CourseHash eu tenho como saber 
todas as informações sobre o curso, como id da compra,
preço, endereço do comprador , proof no formato hash, e os state.
*/