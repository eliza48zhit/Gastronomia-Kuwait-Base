// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Gastronomia_Kuwait
 * @dev Registro de infusion lipidica y gestion de especias maritimas.
 * Optimizacion: Custom Errors para gas y validacion de rangos.
 * Serie: Sabores de Asia (#9)
 */
contract Gastronomia_Kuwait {

    error RangoExcedido(string parametro, uint256 valor);
    error YaVotado(address voter);
    error IDInvalido(uint256 id);
    error NombreRequerido();

    struct Plato {
        string nombre;
        string ingredientes;
        string preparacion;
        uint256 intensidadInfusionGhee; // Nivel de aromatizacion de la grasa (1-100)
        uint256 minutosSelladoProteina; // Tiempo de reaccion de Maillard
        bool utilizaArrozBasmati;       // Validador de grano largo
        uint256 likes;
        uint256 dislikes;
    }

    mapping(uint256 => Plato) public registroCulinario;
    mapping(uint256 => mapping(address => bool)) public hasVoted;
    
    uint256 public totalRegistros;
    address public owner;

    constructor() {
        owner = msg.sender;
        // Inauguramos con el Mutabbaq Samak (Ingenieria del Pescado)
        registrarPlato(
            "Mutabbaq Samak", 
            "Pescado Zubaidi, arroz basmati, especias kuwaities, cebolla caramelizada, ghee.",
            "Infusion de ghee con especias, sellado del pescado y coccion al vapor sobre el arroz.",
            85, 
            12, 
            true
        );
    }

    function registrarPlato(
        string memory _nombre, 
        string memory _ingredientes,
        string memory _preparacion,
        uint256 _infusion, 
        uint256 _sellado,
        bool _arroz
    ) public {
        if (bytes(_nombre).length == 0) revert NombreRequerido();
        if (_infusion > 100) revert RangoExcedido("Infusion Ghee", _infusion);
        if (_sellado > 60) revert RangoExcedido("Minutos Sellado", _sellado);

        totalRegistros++;
        registroCulinario[totalRegistros] = Plato({
            nombre: _nombre,
            ingredientes: _ingredientes,
            preparacion: _preparacion,
            intensidadInfusionGhee: _infusion,
            minutosSelladoProteina: _sellado,
            utilizaArrozBasmati: _arroz,
            likes: 0,
            dislikes: 0
        });
    }

    function darLike(uint256 _id) public {
        if (_id == 0 || _id > totalRegistros) revert IDInvalido(_id);
        if (hasVoted[_id][msg.sender]) revert YaVotado(msg.sender);
        
        registroCulinario[_id].likes++;
        hasVoted[_id][msg.sender] = true;
    }

    function darDislike(uint256 _id) public {
        if (_id == 0 || _id > totalRegistros) revert IDInvalido(_id);
        if (hasVoted[_id][msg.sender]) revert YaVotado(msg.sender);
        
        registroCulinario[_id].dislikes++;
        hasVoted[_id][msg.sender] = true;
    }
}
