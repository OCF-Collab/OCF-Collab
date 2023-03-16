/* global fetch */

export const handler = async (event) => {
    const { id } = event.queryStringParameters || {};
    
    if (!id) {
        return { statusCode: 400, body: { error: 'Missing `id` parameter' } };
    }
    
    try {
        const response = await fetch(id);
        const data = await response.json(); // if your network doesn't respond with a JSON payload, add custom code to convert it
        
        return { statusCode: 200, body: data };
    } catch (e) {
        return { statusCode: 500, body: { error: e.message } };
    }
};
